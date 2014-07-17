require "java"

require "tmpdir"

#java_import com.sun.tools.javac.Main old way

java_import javax.tools.JavaCompiler
java_import javax.tools.ToolProvider

java_import java.io.ByteArrayInputStream
java_import java.io.ByteArrayOutputStream
####java_import java.lang.String

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    #respond_to do |format|
    #            format.html
    #            format.xml  { render :xml => @users } #status?
    #            format.json { render :json => @users, :callback => params[:callback]  } #status?
    #            format.js   { render :json => @users, :callback => params[:callback] } #status?
    #end

    @tmp = Dir.tmpdir
    @tmp2 = Dir.mktmpdir

    javac = ToolProvider.getSystemJavaCompiler()

    @testsource = "public class Practice { public static void main( String args[] ) { System.out.println( \"Hello Web\" ); } }"
    #@args = "-g"
    #source = ByteArrayInputStream.new(@testsource.to_java_bytes)
    #out = ByteArrayOutputStream.new()
    #err = ByteArrayOutputStream.new()

    #@rc = javac.run(@args,out,err,source) #source is last - filename/path as String

    #sjfoc = Class.new(javax.tools.SimpleJavaFileObject) {
    #  c = ""
    #  def initialize(a, b)
    #    #super(java.net.URI.new("TestClass"), javax.tools.JavaFileObject.Kind.SOURCE)
    #    super(java.net.URI.new(a), "SOURCE")
    #    c = b
    #  end
    #  def getCharContent(x)
    #    return c
    #  end
    #}

    #sjfo = sjfoc.new("TestClass", @testsource)

    #@outs = out.to_s
    #@errs = err.to_s
    @testssource2 = @testsource.to_java_bytes.to_s

    #sm = java.lang.System.getSecurityManager()
    #context = sm.getSecurityContext()

    sm = java.lang.SecurityManager.new()
    ###java.lang.System.setSecurityManager( sm )

    #o =  java.lang.Object.new()
    #urls = ["file:/home/testomat/resin/testomat/doc/temp/s766478786/"]
    #urls = { java.net.URL.new( "file:/home/testomat/resin/testomat/doc/temp/s766478786/" ) }
    ###cl = new ExerciseClassLoader( urls, o.getClass().getClassLoader() );
    ###cl = java.net.URLClassLoader( urls.to_java, o.getClass().getClassLoader() )
    ###cl = JRuby.runtime.JRubyClassLoader.new( urls.to_java, o.getClass().getClassLoader() )
    cl = JRuby.runtime.jruby_class_loader
    #cl.add_url(F.new('hello_world_directory').to_url)
    ###cl.add_url("file:/home/testomat/resin/testomat/doc/temp/s766478786/")
    #exercise = cl.loadClass("Exercise021")

    installed = java.nio.file.spi.FileSystemProvider.installedProviders()
    plist = installed.listIterator()
    @count = installed.size()
    @plist1 = plist.next().getScheme()
    @plist2 = plist.next().getScheme()

  end

  # GET /users/1
  # GET /users/1.json
  def show
   #   respond_to do |format|
   #               format.html
   #               format.xml { render :xml => @user } #status?
   #               format.json { render :json => @user, :callback => params[:callback]  } #status?
   #               format.js   { render :json => @user, :callback => params[:callback] } #status?
   #               end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
