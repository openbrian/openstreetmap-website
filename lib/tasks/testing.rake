namespace :test do
  task "lib" => "test:prepare" do
    $LOAD_PATH << "test"
    Rails::TestUnit::Runner.rake_run(["test/lib"])
  end
end
