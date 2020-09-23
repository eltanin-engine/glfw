module GLFW
  class Window
    property width
    property height
    property title
    property handle : LibGLFW::Window

    @statistics = {
      :frames => 0
    }

    def initialize(@width = 1024, @height = 768, @title = "")
      raise "Failed to initialize GLFW" unless LibGLFW.init

      LibGLFW.window_hint LibGLFW::SAMPLES, 4
      LibGLFW.window_hint LibGLFW::CONTEXT_VERSION_MAJOR, 3
      LibGLFW.window_hint LibGLFW::CONTEXT_VERSION_MINOR, 3
      LibGLFW.window_hint LibGLFW::OPENGL_FORWARD_COMPAT, 1
      LibGLFW.window_hint LibGLFW::OPENGL_PROFILE, LibGLFW::OPENGL_CORE_PROFILE
      @handle = LibGLFW.create_window @width, @height, @title, nil, nil

      raise "Failed to open GLFW window" if @handle.is_a?(Nil)
    end

    def set_context_current
      LibGLFW.make_context_current @handle
    end

    def log_stats
      @statistics[:frames] += 1
    end

    def open(&block)
      set_context_current

      while true

        log_stats
        LibGLFW.poll_events
        LibGLFW.swap_buffers @handle
        break if LibGLFW.get_key(@handle, LibGLFW::KEY_ESCAPE) == LibGLFW::PRESS && LibGLFW.window_should_close(@handle)
        yield
      end

      LibGLFW.terminate
    end

  end
end
