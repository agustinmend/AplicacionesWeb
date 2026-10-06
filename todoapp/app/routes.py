from flask import Blueprint, flash, redirect, render_template, request, url_for
from .extensions import db
from .models import Todo
bp = Blueprint("todos", __name__)

@bp.route("/")
def index():
    todos = Todo.query.order_by(Todo.completed.asc(), Todo.created_at.desc()).all()
    return render_template("index.html", todos=todos)

@bp.route("/todos", methods=["POST"])
def create():
    title = request.form.get("title", "").strip()
    description = request.form.get("description", "").strip()
    if not title:
        flash("Title is required.", "error")
        return redirect(url_for("todos.index"))
    try:
        db.session.add(Todo(title=title, description=description))
        db.session.commit()
        flash("Todo created.", "success")
    except Exception as e:
        db.session.rollback()
        flash("Error al crear: ", "error")
    return redirect(url_for("todos.index"))

@bp.route("/todos/<int:todo_id>/edit", methods=["GET", "POST"])
def edit(todo_id):
    todo = Todo.query.get_or_404(todo_id)
    if request.method == "POST":
        title = request.form.get("title", "").strip()
        description = request.form.get("description", "").strip()
        if not title:
            flash("Title is required.", "error")
            return render_template("edit.html", todo=todo)
        try:
            todo.title = title
            todo.description = description
            db.session.commit()
            flash("Todo updated.", "success")
            return redirect(url_for("todos.index"))
        except Exception as e:
            db.session.rollback()
            flash("Error updating todo.", "error")
    return render_template("edit.html", todo=todo)

@bp.route("/todos/<int:todo_id>/delete", methods=["POST"])
def delete(todo_id):
    todo = Todo.query.get_or_404(todo_id)
    try:
        db.session.delete(todo)
        db.session.commit()
        flash("deleted.", "success")
    except Exception as e:
        db.session.rollback()
        flash("Error al eliminar.", "error")
    return redirect(url_for("todos.index"))