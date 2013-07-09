class ActivationsController < ApplicationController

  def update
    @user = User.find_by_activation_token! params[:id]
    if @user.activation_sent_at < 2.hours.ago
      # FIXME: forse meglio mettere 2 giorni
      flash[:error] = I18n.t('activations.expired')
      # TODO: cancellare l'utente così si può ri-registrare
      redirect_to signup_path
    else
      @user.activate!
      flash[:success] = I18n.t('activations.success')
      redirect_to signin_path
    end
  end

end
