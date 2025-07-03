import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory
import com.android.build.gradle.AppExtension
import com.android.build.gradle.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Di chuyển thư mục build ra ngoài nếu cần
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Đảm bảo mọi subproject phụ thuộc đúng
subprojects {
    project.evaluationDependsOn(":app")
}

// Ép tất cả module dùng NDK version 27.0.12077973
subprojects {
    plugins.withId("com.android.application") {
        extensions.configure<AppExtension> {
            ndkVersion = "27.0.12077973"
        }
    }
    plugins.withId("com.android.library") {
        extensions.configure<LibraryExtension> {
            ndkVersion = "27.0.12077973"
        }
    }
}

// Task clean
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
