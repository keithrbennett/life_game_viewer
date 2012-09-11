
# Main entry point into the application.
module LifeGameViewer
  class Main


    def self.view_sample
      LifeGameViewerFrame.view_sample
    end

    def self.view(model)
      LifeGameViewerFrame.new(model).visible = true
    end

  end
end
