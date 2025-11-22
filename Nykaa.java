package Week5Day4;

import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import org.openqa.selenium.interactions.Actions;

import io.github.bonigarcia.wdm.WebDriverManager;

public class Nykaa { 
	public static void main(String[] args) {
		WebDriverManager.chromedriver().setup();
		ChromeOptions option=new ChromeOptions();
		
		WebDriverManager.chromedriver().setup();
		ChromeDriver driver=new ChromeDriver();
		driver.get("https://www.nykaa.com/");
		driver.manage().window().maximize();
		
		WebElement Brands = driver.findElement(By.xpath("//a[text()='brands']"));
		Actions builder=new Actions(driver);
		builder.moveToElement(Brands).perform();
		driver.findElement(By.xpath("//input[@placeholder='Search on Nykaa']")).sendKeys("L'Oreal Paris",Keys.ENTER);
		String title = driver.findElement(By.xpath("//span[text()='Showing 20 of 221 results for ']/following::h1")).getText();
	     String title1=driver.getTitle();
	     System.out.println(title1); 
	     driver.findElement(By.xpath("//button[@class=' css-n0ptfk']//.")).click();
	     driver.findElement(By.xpath("(//div[@class='control-indicator radio '])[3]")).click();
	     driver.findElement(By.xpath("//div[@class='css-xdicx1']")).click();
	     driver.findElement(By.xpath("(//span[@class='side-count'])[2]")).click();
	     driver.findElement(By.xpath("(//span[@class='side-count'])[2]")).click();
	     driver.findElement(By.xpath("//div[@class='control-indicator checkbox ']")).click();
	     driver.findElement(By.xpath("(//span[@class='side-count'])[3]")).click(); 
	     
		
		
		
	}

}
