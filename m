From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [27/27]
Date: Thu, 17 Feb 2005 12:38:46 -0500
Message-ID: <4214D6A6.4010100@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:23443 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262343AbVBQRiv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:38:51 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHcor32125
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:38:50 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHcnb21913
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:38:49 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The readme file.

diff -Nru a/drivers/scsi/adp94xx/readme.txt b/drivers/scsi/adp94xx/readme.txt
--- /dev/null	Wed Dec 31 16:00:00 196900
+++ b/drivers/scsi/adp94xx/readme.txt	2005-02-16 16:08:12 -05:00
@@ -0,0 +1,289 @@
+====================================================================
+=            Adaptec SAS/SATA Family Manager Set v1.0.0            =
+=                                                                  =
+=                            README for                            =
+=                  Red Hat Linux Advanced Server 2.1               =
+=		   Red Hat Enterprise Linux 3.0                    =	
+=           SuSE Linux Enterprise Server 8 / UnitedLinux 1.0       =
+=                   SuSE Linux Enterprise Server 9                 =
+=                                                                  =
+= $Id: //depot/razor/linux/src/readme.txt#11 $                     =
+====================================================================
+
+0. Supported Hardware
+
+   The following Adaptec SAS/SATA Host Adapters are supported by this 
+   driver set. 
+
+   SAS/SATA Adapters          Description
+   ----------------------------------------------------------------
+   ASC-48300                  Eight port SAS and SATA 64-bit PCI-X
+                              133MHz to SAS/SATA host bus adapter
+                              with 4X SFF-8484 internal connector
+                              and 4X SFF-8470 external connector.
+   AIC-9410                   Eight port SAS and SATA 64-bit PCI-X
+                              133MHz ASIC.
+
+
+1. Version History
+   1.0.0, November 1st, 2004, Initial driver release.
+
+1.1. Software/Hardware Features
+     - Support for the Serial Attached SCSI (SAS) protocol
+       as specified in T10/1562-D specification, Revision 5.
+     - Protocol supported: SSP, STP and SMP.
+     - Support for ATA/ATAPI protocols as specified in
+       ATA/ATAPI-7 V1, Revision 4b and ATA/ATAPI-7 V3,
+       Revision 4a.
+     - Protocol supported: SATA and ATAPI.
+     - Initiator Mode (target mode not currently supported)
+     - Support for the PCI-x standard up to 133MHz
+     - Support for the PCI v2.2 standard
+
+1.2. Kernel support
+     2.4.x, x86, AMD64 and EM64T
+     2.6.x, x86, AMD64 and EM64T
+
+     Refer to the User's Guide for more details.
+
+2. Installation Instructions
+
+2.1. Installing Red Hat Linux Advanced Server 2.1 /
+     Enterprise Linux 3.0 with a SAS/SATA Host Adapter
+
+     1) Install the SAS/SATA adapter and power on your
+        system.
+     2) Boot from the Red Hat CDROM.
+     3) At the boot menu, type 'linux dd' and press ENTER.
+     4) Follow the on-screen prompts to insert the Adaptec
+        Red Hat driver disk.
+     5) Proceed with the normal Red Hat installation steps.
+
+2.2. Installing SuSE Linux Enterprise Server 8, UnitedLinux
+     1.0, SuSE Linux Enterprise Server 9 with a SAS/SATA
+     Host Adapter
+
+     1) Install the SAS/SATA adapter and power on your system.
+     2) Boot from the SuSE CDROM.
+     3) At the boot menu, press the ALT key to stop the boot.
+        For SLES 9, use F6 key instead ALT key.
+     4) Press 'Enter' and follow the on-screen prompts to insert
+        the Adaptec SuSE driver disk.
+     5) Proceed with the normal SuSE installation steps.
+
+2.3. Installing the Driver when Red Hat or SuSE is Already
+     Installed
+
+     1) Download the Adaptec driver RPM file appropriate to
+        your version of Red Hat/SuSE.
+     2) From a shell prompt, type: rpm -ivh <RPM file>
+     3) Make sure to reboot the system by issuing the
+        command "shutdown -h now". After the system reboots,
+        the procedure is then done.
+ 
+2.3. Removing the Driver
+
+     Removing the Adaptec SAS/SATA driver is not presently supported.
+
+3. Command Line Options
+
+        WARNING: ALTERING OR ADDING THESE DRIVER PARAMETERS
+                 INCORRECTLY CAN RENDER YOUR SYSTEM INOPERABLE.
+                 USE THEM WITH CAUTION. 
+
+   Module parameters for loadable modules are specified only
+   as the parameter name with optional '=' and value as
+   appropriate, such as:
+
+       modprobe adp94xx attach_HostRAID=1 cmd_per_lun=10
+
+   Module parameters for modules that are built into the kernel image
+   are specified on the kernel command line.
+
+   2.6.x: The module name plus '.' plus parameter name, with
+     '=' and value if appropriate, such as:
+
+        adp94xx.attach_HostRAID=1 adp94xx.cmd_per_lun=10
+
+   2.4.x: The module name plus '=', plus the parameters,
+     assignment is done by ':', parameters are period separated, such as:
+
+        adp94xx=attach_HostRAID:1.cmd_per_lun:10
+	    
+   The parameters are:
+
+   cmd_per_lun:<int>
+	Global tag depth for all targets on all ports.
+	This option sets the default tag depth for all
+	targets if they support tag-queueing.
+	Default Value: 32, range 1 to 64.
+
+   attach_HostRAID:<int>
+	Controls whether the driver should atttach to
+	HostRAID enabled controllers.
+	Default: 0, false, the driver would *not* attach to
+	RAID enabled controllers.  To make the driver
+	attach to RAID controllers, turn this on by setting
+	it to 1.
+
+   debug_mask:<int>
+	Sets the debug mask for the driver.  Must be compiled
+	with ASD_DEBUG macro defined for this to work. Default: 0.
+
+   To see complete list of parameters, try "modinfo -p <module>".
+
+4. Additional Notes
+
+4.1. Known/Unresolved or FYI Issues
+
+4.2. Third-Party Compatibility Issues
+
+     Adaptec only supports SAS and SATA hard drives running
+     the latest firmware available. Please check with your
+     hard drive manufacturer to ensure you have the latest
+     version.
+
+4.3. Operating System or Technology Limitations
+
+     * PCI Hot Plug is untested, use at your own risk!
+
+     * Sparse LUN space may not be automatically probed.
+       This is a limitation of some kernels.  Contact your
+       OS vendor for support on this.
+
+     * Using the Driver Update Disk version of this package
+       during OS installation under Red Hat might result in
+       two versions of this driver being installed into the
+       system module directory.  This might cause problems
+       with the /sbin/mkinitrd program and/or other RPM
+       packages that try to install system modules.  The
+       best way to correct this once the system is running
+       is to install the latest RPM package version of this
+       driver, available from http://www.adaptec.com/.
+
+
+5. Diskette Structure (obsolete section)
+
+   Red Hat Advanced Server 2.1 (x86):
+   modules.cgz
+   modules.dep
+   pcitable
+   readme.txt
+   rhdd-6.1
+
+   Red Hat Enterprise Linux 3.0 (x86):
+   modules.cgz
+   modules.dep
+   pcitable
+   readme.txt
+   rhdd-6.1
+
+   Red Hat Enterprise Linux 3.0 (AMD64, EM64/T):
+   modules.cgz
+   modules.dep
+   pcitable
+   readme.txt
+   rhdd
+
+   SuSE Linux Enterprise Server 8, UnitedLinux 1.0 (x86):
+   readme.txt
+   linux/UnitedLinux/i386-ul1/install/update.post
+   linux/UnitedLinux/i386-ul1/install/update.pre
+   linux/UnitedLinux/i386-ul1/install/update.tar.gz
+   linux/UnitedLinux/i386-ul1/modules/adp94xx.o
+
+   SuSE Linux Enterprise Server 8, UnitedLinux 1.0 (AMD64, EM64/T):
+   readme.txt
+   linux/UnitedLinux/x86_64-ul1/install/update.post
+   linux/UnitedLinux/x86_64-ul1/install/update.pre
+   linux/UnitedLinux/x86_64-ul1/install/update.tar.gz
+   linux/UnitedLinux/x86_64-ul1/modules/adp94xx.o
+
+   SuSE Linux Enterprise Server 9 (x86):
+   readme.txt
+   linux/suse/i386-sles9/install/update.post
+   linux/suse/i386-sles9/install/update.pre
+   linux/suse/i386-sles9/install/update.tar.gz
+   linux/suse/i386-sles9/modules/adp94xx.ko
+   linux/suse/i386-sles9/y2update/modules/Vendor.ycp
+   
+   SuSE Linux Enterprise Server 9 (AMD64, EM64/T):
+   readme.txt
+   linux/suse/x86_64-sles9/install/update.post
+   linux/suse/x86_64-sles9/install/update.pre
+   linux/suse/x86_64-sles9/install/update.tar.gz
+   linux/suse/x86_64-sles9/modules/adp94xx.ko
+   linux/suse/x86_64-sles9/y2update/modules/Vendor.ycp
+   
+6. Contacting Adaptec
+
+   A Technical Support Identification (TSID) Number is required for 
+   Adaptec technical support.
+    - The 12-digit TSID can be found on the white barcode-type label
+      included inside the box with your product. The TSID helps us 
+      provide more efficient service by accurately identifying your 
+      product and support status.
+   Support Options
+    - Search the Adaptec Support Knowledgebase (ASK) at
+      http://ask.adaptec.com for articles, troubleshooting tips, and
+      frequently asked questions for your product.
+    - For support via Email, submit your question to Adaptec's 
+      Technical Support Specialists at http://ask.adaptec.com.
+     
+   North America
+    - Visit our Web site at http://www.adaptec.com.
+    - To speak with a Fibre Channel/RAID/External Storage Technical
+      Support Specialist, call 1-321-207-2000,
+      Hours: Monday-Friday, 3:00 A.M. to 5:00 P.M., PST.
+      (Not open on holidays)
+    - For Technical Support in all other technologies including 
+      SAS, call 1-408-934-7274,
+      Hours: Monday-Friday, 6:00 A.M. to 5:00 P.M., PST.
+      (Not open on holidays)
+    - For after hours support, call 1-800-416-8066 ($99/call, 
+      $149/call on holidays)
+    - To order Adaptec products including software and cables, call
+      1-800-442-7274 or 1-408-957-7274. You can also visit our 
+      online store at http://www.adaptecstore.com
+
+   Europe
+    - Visit our Web site at http://www.adaptec-europe.com.
+    - English and French: To speak with a Technical Support 
+      Specialist, call one of the following numbers:
+        - English: +32-2-352-3470
+        - French:  +32-2-352-3460
+      Hours: Monday-Thursday, 10:00 to 12:30, 13:30 to 17:30 CET 
+             Friday, 10:00 to 12:30, 13:30 to 16:30 CET
+    - German: To speak with a Technical Support Specialist,
+      call +49-89-456-40660
+      Hours: Monday-Thursday, 09:30 to 12:30, 13:30 to 16:30 CET
+             Friday, 09:30 to 12:30, 13:30 to 15:00 CET
+    - To order Adaptec products, including accessories and cables:
+        - UK: +0800-96-65-26 or fax +0800-731-02-95
+        - Other European countries: +32-11-300-379
+
+   Australia and New Zealand
+    - Visit our Web site at http://www.adaptec.com.au.
+    - To speak with a Technical Support Specialist, call 
+      +612-9416-0698
+      Hours: Monday-Friday, 10:00 A.M. to 4:30 P.M., EAT
+      (Not open on holidays)
+
+   Japan
+    - To speak with a Technical Support Specialist, call 
+      +81-3-5308-6120 
+      Hours: Monday-Friday, 9:00 a.m. to 12:00 p.m., 1:00 p.m. to
+      6:00 p.m. TSC
+
+   Hong Kong and China
+    - To speak with a Technical Support Specialist, call 
+      +852-2869-7200
+      Hours: Monday-Friday, 10:00 to 17:00.
+    - Fax Technical Support at +852-2869-7100.
+
+   Singapore
+    - To speak with a Technical Support Specialist, call 
+      +65-245-7470
+      Hours: Monday-Friday, 10:00 to 17:00.
+    - Fax Technical Support at +852-2869-7100
+

