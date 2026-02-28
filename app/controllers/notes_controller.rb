class NotesController < ApplicationController
  before_action :set_patient

  def create
    @note = @patient.notes.build(note_params)
    @note.clinic = Current.clinic
    @note.user = Current.user
    authorize @note

    if @note.save
      ActivityTracker.track(@note, action: "created")
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @patient }
      end
    else
      render turbo_stream: turbo_stream.replace("new_note_form", partial: "notes/form", locals: { patient: @patient, note: @note })
    end
  end

  def update
    @note = @patient.notes.find(params[:id])
    authorize @note

    if @note.update(note_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @patient }
      end
    else
      render turbo_stream: turbo_stream.replace(@note, partial: "notes/form", locals: { patient: @patient, note: @note })
    end
  end

  def destroy
    @note = @patient.notes.find(params[:id])
    authorize @note
    @note.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@note) }
      format.html { redirect_to @patient }
    end
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
