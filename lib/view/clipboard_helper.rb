# Simplifies the use of the system clipboard access via Java.
class ClipboardHelper

  def self.clipboard
    Toolkit.default_toolkit.system_clipboard
  end

  def self.clipboard_text
    transferable = @clipboard_helper.clipboard.getContents(self)
    transferable.getTransferData(DataFlavor::stringFlavor)
  end

  def self.mac_os?
    /^Mac/ === java.lang.System.properties['os.name']
  end

  # For getting descriptive text for, e.g. tooltips.
  def self.key_prefix
    mac_os? ? "Command" : "Ctrl"
  end

  # Gets the first Action object associated with the passed action_name.
  def self.input_action_key(action_name)
    map = UIManager.get("TextField.focusInputMap")
    map.keys.select { |key| map.get(key) == action_name }.first
  end

  # Name of copy key for this OS.
  def self.copy_key_name
    input_action_key("copy-to-clipboard").to_string
  end

  # Name of paste key for this OS.
  def self.paste_key_name
    input_action_key("paste-from-clipboard").to_string
  end

end