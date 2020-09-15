class FixturesController < ApplicationController
  before_action :set_fixture, only: %i[show edit update]

  def import
    @fixture = ImportFixtureJob.perform_now(params[:file])
    redirect_to fixture_path(@fixture), notice: "Fixture data imported"
  end

  def index
    @fixtures = Fixture.all.sort_by{ |fixture| fixture.days_until_completion }
    @fixture = Fixture.new
  end

  def show
    @fixture_cargo = FixtureCargo.new
  end

  def new
  end

  def create
    @fixture = Fixture.new(fixture_params)
    @fixture.save!

    redirect_to fixture_path(@fixture)
  end

  def edit
  end

  def update
    @fixture.update(fixture_params)

    redirect_to fixture_path(@fixture)
  end

  private

  def set_fixture
    @fixture = Fixture.find(params[:id])
  end

  def fixture_params
    params.fetch(:fixture, {}).permit(:charterer, :clause_group_id, :vessel_name, :voyage_number, :demurrage_rate, :allowed_laytime,
                                      # Used for cocoon nesting forms to pass all FixtureCargo attributes and destroy method in params
                                      cargoes_attributes: FixtureCargo.attribute_names.map(&:to_sym).push(:_destroy))
  end
end
