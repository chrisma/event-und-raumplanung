// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require knockout

$(function()
{
	handleTaskCheckboxClick();
});
$(document).on('page:load', handleTaskCheckboxClick);

function handleTaskCheckboxClick()
{
	$(".task-done-checkbox").click(function(event)
	{
		var target = event.target;
		var taskPath = $(target).attr('data-taskpath');
		$.ajax({
			url: taskPath,
			type: 'PUT',
			data: {task: {done: target.checked}},
			dataType: 'json'
		});
	});
}