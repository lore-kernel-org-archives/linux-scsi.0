From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 2/5]  arcmsr: Support Hibernation
Date: Fri, 8 Feb 2013 14:02:41 +0800
Message-ID: <1EB796BACAC44E2EABDE58C8B47B4E8F@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0003_01CE0604.F6D96040"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org, ??? <ching2048@areca.com.tw>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0003_01CE0604.F6D96040
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Support hibernation for whole series of RAID controllers
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_0003_01CE0604.F6D96040
Content-Type: application/octet-stream;
	name="checkpatch2"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="checkpatch2"

WARNING: Too many leading tabs - consider code refactoring=0A=
#70: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:567:=0A=
+							if (psdev !=3D NULL) {=0A=
=0A=
WARNING: line over 80 characters=0A=
#71: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:568:=0A=
+								scsi_remove_device(psdev);=0A=
=0A=
WARNING: line over 80 characters=0A=
#72: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:569:=0A=
+								scsi_device_put(psdev);=0A=
=0A=
WARNING: braces {} are not necessary for single statement blocks=0A=
#96: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:692:=0A=
+			for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {=0A=
+				free_irq(acb->entries[i].vector, acb);=0A=
+			}=0A=
=0A=
WARNING: printk() should include KERN_ facility level=0A=
#127: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:723:=0A=
+			printk("%s: pci_enable_device error\n", __func__);=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#150: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:746:=0A=
+						for (j =3D 0 ; j < i ; j++)=0A=
=0A=
WARNING: line over 80 characters=0A=
#151: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:747:=0A=
+							free_irq(entries[i].vector,=0A=
=0A=
WARNING: printk() should include KERN_ facility level=0A=
#159: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:755:=0A=
+				printk("arcmsr%d: MSI-X"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#160: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:756:=0A=
+				printk("arcmsr%d: MSI-X"=0A=
+				"failed to enable\n", acb->host->host_no);=0A=
=0A=
WARNING: braces {} are not necessary for single statement blocks=0A=
#168: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:764:=0A=
+			if (!pci_enable_msi(pdev)) {=0A=
+				acb->acb_flags |=3D ACB_F_MSI_ENABLED;=0A=
+			}=0A=
=0A=
WARNING: quoted string split across lines=0A=
#231: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1100:=0A=
 			pr_notice("arcmsr%d: scsi id =3D %d lun =3D %d"=0A=
+				"isr get command error done, but got unknown"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#263: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2403:=0A=
 		pr_notice("arcmsr%d: wait 'get adapter firmware"=0A=
+			"miscellaneous data' timeout\n",=0A=
=0A=
ERROR: Missing Signed-off-by: line(s)=0A=
=0A=
total: 1 errors, 12 warnings, 259 lines checked=0A=
=0A=
../patch2 has style problems, please review.=0A=
=0A=
If any of these errors are false positives, please report=0A=
them to the maintainer, see CHECKPATCH in MAINTAINERS.=0A=

------=_NextPart_000_0003_01CE0604.F6D96040--
