From: Rob Landley <rob@landley.net>
Subject: [PATCH] Update Documentation/scsi/00-INDEX
Date: Sun, 30 Sep 2007 23:23:39 -0500
Message-ID: <200709302323.40078.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-doc-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update Documentation/scsi/00-INDEX to match current files.

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/scsi/00-INDEX |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff -r f4ca99897c12 Documentation/scsi/00-INDEX
--- a/Documentation/scsi/00-INDEX	Sat Sep 29 10:00:15 2007 -0700
+++ b/Documentation/scsi/00-INDEX	Sun Sep 30 23:21:01 2007 -0500
@@ -2,14 +2,20 @@ 00-INDEX
 	- this file
 53c700.txt
 	- info on driver for 53c700 based adapters
-AM53C974.txt
-	- info on driver for AM53c974 based adapters
 BusLogic.txt
 	- info on driver for adapters with BusLogic chips
-ChangeLog
+ChangeLog.1992-1997
 	- Changes to scsi files, if not listed elsewhere
+ChangeLog.arcmsr
+	- Changes to driver for ARECA's SATA RAID controller cards
 ChangeLog.ips
 	- IBM ServeRAID driver Changelog
+ChangeLog.lpfc
+	- Changes to lpfc driver
+ChangeLog.megaraid
+	- Changes to LSI megaraid controller.
+ChangeLog.megaraid_sas
+	- Changes to serial attached scsi version of LSI megaraid controller.
 ChangeLog.ncr53c8xx
 	- Changes to ncr53c8xx driver
 ChangeLog.sym53c8xx
@@ -20,26 +26,44 @@ FlashPoint.txt
 	- info on driver for BusLogic FlashPoint adapters
 LICENSE.FlashPoint
 	- Licence of the Flashpoint driver
+LICENSE.qla2xxx
+	- License for QLogic Linux Fibre Channel HBA Driver firmware.
 Mylex.txt
 	- info on driver for Mylex adapters
 NinjaSCSI.txt
 	- info on WorkBiT NinjaSCSI-32/32Bi driver
+aacraid.txt
+	- Driver supporting Adaptec RAID controllers
 aha152x.txt
 	- info on driver for Adaptec AHA152x based adapters
+aic79xx.txt
+	- Adaptec Ultra320 SCSI host adapters
 aic7xxx.txt
 	- info on driver for Adaptec controllers
 aic7xxx_old.txt
 	- info on driver for Adaptec controllers, old generation
+arcmsr_spec.txt
+	- ARECA FIRMWARE SPEC (for IOP331 adapter)
+dc395x.txt
+	- README file for the dc395x SCSI driver
 dpti.txt
 	- info on driver for DPT SmartRAID and Adaptec I2O RAID based adapters
 dtc3x80.txt
 	- info on driver for DTC 2x80 based adapters
 g_NCR5380.txt
 	- info on driver for NCR5380 and NCR53c400 based adapters
+hptiop.txt
+	- HIGHPOINT ROCKETRAID 3xxx RAID DRIVER
 ibmmca.txt
 	- info on driver for IBM adapters with MCA bus
 in2000.txt
 	- info on in2000 driver
+libsas.txt
+	- Serial Attached SCSI management layer.
+lpfc.txt
+	- LPFC driver release notes
+megaraid.txt
+	- Common Management Module, shared code handling ioctls for LSI drivers
 ncr53c7xx.txt
 	- info on driver for NCR53c7xx based adapters
 ncr53c8xx.txt
@@ -50,6 +74,8 @@ ppa.txt
 	- info on driver for IOmega zip drive
 qlogicfas.txt
 	- info on driver for QLogic FASxxx based adapters
+scsi-changer.txt
+	- README for the SCSI media changer driver
 scsi-generic.txt
 	- info on the sg driver for generic (non-disk/CD/tape) SCSI devices.
 scsi.txt
@@ -58,6 +84,8 @@ scsi_mid_low_api.txt
 	- info on API between SCSI layer and low level drivers
 scsi_eh.txt
 	- info on SCSI midlayer error handling infrastructure
+scsi_fc_transport.txt
+	- SCSI Fiber Channel Tansport
 st.txt
 	- info on scsi tape driver
 sym53c500_cs.txt

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
