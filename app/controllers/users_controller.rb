require "java"

require "tmpdir"

require "jruby"

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

    sm = java.lang.SecurityManager.new()
    ###java.lang.System.setSecurityManager( sm )

    @tmp = Dir.tmpdir
    @tmp2 = Dir.mktmpdir

    $CLASSPATH << @tmp2.to_s # don't need?

    javac = ToolProvider.getSystemJavaCompiler()

    #@testsource = "public class Practice { public static void main( String args[] ) { System.out.println( \"Hello Web\" ); } }"
    #testsource2 = "-help"

    @testsource = "package test; public class Practice { public String hello() { System.out.println( \"Hello Web\" ); return \"hell!\"; } }"

    Dir.chdir(@tmp2)
    @testdir = Dir.mkdir("test")

    @tmpfilename = File.join(@tmp2.to_s+"/test/","Practice.java")
    tmpfile = File.new(@tmpfilename, "w")
    tmpfile.puts(@testsource)
    tmpfile.close

    @args = "-g"
    source = ByteArrayInputStream.new("".to_java_bytes)
    out = ByteArrayOutputStream.new()
    err = ByteArrayOutputStream.new()

    @rc = javac.run(source,out,err,@tmpfilename)

    @outs = out.to_s
    @errs = err.to_s
    @testssource2 = @testsource.to_java_bytes.to_s

    classfilename = File.join(@tmp2.to_s+"/test/","Practice")

    #sm = java.lang.System.getSecurityManager()
    #context = sm.getSecurityContext()

    #o =  java.lang.Object.new()
    #urls = ["file:/home/testomat/resin/testomat/doc/temp/s766478786/"]
    #urls = { java.net.URL.new( "file:/home/testomat/resin/testomat/doc/temp/s766478786/" ) }
    ###cl = new ExerciseClassLoader( urls, o.getClass().getClassLoader() );
    ###cl = java.net.URLClassLoader( urls.to_java, o.getClass().getClassLoader() )
    ###cl = JRuby.runtime.JRubyClassLoader.new( urls.to_java, o.getClass().getClassLoader() )
    #cl = JRuby.runtime.jruby_class_loader
    #cl.add_url(F.new('hello_world_directory').to_url)
    #cl.add_url(java.net.URL.new("file:/"+@tmp2))
    ###cl.add_url("file:"+@tmp2)

#    cl = JRuby.runtime.jruby_class_loader
#    @cpURL = "file:/"+@tmp2.to_s
#    cl.add_url(java.net.URL.new(@cpURL))
#    exercise = cl.loadClass("Practice")

    @cpURL = "file:/"+@tmp2.to_s
    urls = [java.net.URL.new(@cpURL)]
    cl = java.net.URLClassLoader.new( (urls.to_java Java::java::net::URL), JRuby.runtime.jruby_class_loader )
    @cp = cl.getURLs()
    exerciseClass = cl.loadClass("test.Practice")

    constr = exerciseClass.getConstructor()
#    @retVal = exerciseClass.getCanonicalName()
    instnc = exerciseClass.getConstructor().newInstance()
    methd = instnc.java_method :hello, []
    @retVal = methd.call()

    installed = java.nio.file.spi.FileSystemProvider.installedProviders()
    plist = installed.listIterator()
    @count = installed.size()
    @plist1 = plist.next().getScheme()
    @plist2 = plist.next().getScheme()

    #clean up

    cl = NIL
    File.delete(tmpfile)
    File.delete("test/Practice.class")

    Dir.rmdir(@tmp2.to_s+"/test")
    Dir.rmdir(@tmp2)

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
