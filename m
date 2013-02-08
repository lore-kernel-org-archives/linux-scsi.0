From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 3/5]  arcmsr: Support MSI and MSI-X
Date: Fri, 8 Feb 2013 14:02:46 +0800
Message-ID: <F09D285F14A941CA929D3AAC3992BA8C@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0006_01CE0604.FA361FD0"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org, ??? <ching2048@areca.com.tw>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0006_01CE0604.FA361FD0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Support MSI or MSI-X for whole series of RAID controllers. Meanwhile correct the register access as iowrite32/ioread32 
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_0006_01CE0604.FA361FD0
Content-Type: application/octet-stream;
	name="checkpatch3"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="checkpatch3"

WARNING: printk() should include KERN_ facility level=0A=
#42: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:885:=0A=
+				printk("arcmsr%d: request_irq =3D %d failed!\n",=0A=
=0A=
WARNING: braces {} are not necessary for any arm of this statement=0A=
#71: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:926:=0A=
+	if (acb->acb_flags & ACB_F_MSI_ENABLED) {=0A=
[...]=0A=
+	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
[...]=0A=
=0A=
ERROR: Missing Signed-off-by: line(s)=0A=
=0A=
total: 1 errors, 2 warnings, 114 lines checked=0A=
=0A=
../patch3 has style problems, please review.=0A=
=0A=
If any of these errors are false positives, please report=0A=
them to the maintainer, see CHECKPATCH in MAINTAINERS.=0A=

------=_NextPart_000_0006_01CE0604.FA361FD0--
