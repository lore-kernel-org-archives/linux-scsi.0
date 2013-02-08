From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 4/5]  arcmsr: Support a New RAID Model, ARC-1214
Date: Fri, 8 Feb 2013 14:02:58 +0800
Message-ID: <21CB1F39001C437A9ED005546E7A603C@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0009_01CE0605.027D91F0"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org, ??? <ching2048@areca.com.tw>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0009_01CE0605.027D91F0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Add a New RAID Model, ARC-1214, which can support 8 SATA HDs at most, so far.
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_0009_01CE0605.027D91F0
Content-Type: application/octet-stream;
	name="checkpatch4"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="checkpatch4"

WARNING: msleep < 20ms can sleep for up to 20ms; see =
Documentation/timers/timers-howto.txt=0A=
+		msleep(10);=0A=
WARNING: line over 80 characters=0A=
#428: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:496:=0A=
+	int retry_count =3D 6;/* enlarge wait flush adapter cache time: 10 =
minute */=0A=
=0A=
WARNING: quoted string split across lines=0A=
#458: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:531:=0A=
+			pr_notice("arcmsr%d: wait 'flush adapter"=0A=
+			"cache' timeout, retry count down =3D %d\n",=0A=
=0A=
WARNING: quoted string split across lines=0A=
#531: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:598:=0A=
+			pr_notice("arcmsr%d: dma_alloc_coherent"=0A=
+			"got error\n", acb->host->host_no);=0A=
=0A=
WARNING: quoted string split across lines=0A=
#621: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:671:=0A=
+			pr_notice("arcmsr%d: dma_alloc_coherent"=0A=
+			"got error\n", acb->host->host_no);=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#707: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:776:=0A=
+						if (psdev !=3D NULL) {=0A=
=0A=
WARNING: line over 80 characters=0A=
#708: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:777:=0A=
+							scsi_remove_device(psdev);=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#810: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:907:=0A=
+						if ((temp & 0x01) =3D=3D 1 &&=0A=
=0A=
WARNING: line over 80 characters=0A=
#812: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:909:=0A=
+							scsi_add_device(acb->host,=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#814: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:911:=0A=
+						} else if ((temp & 0x01) =3D=3D 0=0A=
=0A=
WARNING: line over 80 characters=0A=
#816: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:913:=0A=
+							psdev =3D scsi_device_lookup(acb->host,=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#818: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:915:=0A=
+							if (psdev !=3D NULL) {=0A=
=0A=
WARNING: line over 80 characters=0A=
#819: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:916:=0A=
+								scsi_remove_device(psdev);=0A=
=0A=
WARNING: line over 80 characters=0A=
#820: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:917:=0A=
+								scsi_device_put(psdev);=0A=
=0A=
WARNING: quoted string split across lines=0A=
#978: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1008:=0A=
+			pr_warn("arcmsr%d: MSI-X"=0A=
+			"failed to enable\n", acb->host->host_no);=0A=
=0A=
WARNING: quoted string split across lines=0A=
#1102: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1213:=0A=
 		pr_notice("arcmsr%d: wait 'abort all outstanding"=0A=
+		"command' timeout\n"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#1111: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1229:=0A=
 		pr_notice("arcmsr%d: wait 'abort all outstanding"=0A=
+		"command' timeout\n"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#1120: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1243:=0A=
 		pr_notice("arcmsr%d: wait 'abort all outstanding"=0A=
+		"command' timeout\n"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#1133: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1256:=0A=
+		pr_notice("arcmsr%d: wait 'abort all outstanding"=0A=
+		"command' timeout\n"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#1178: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1424:=0A=
 			pr_notice("arcmsr%d: scsi id =3D %d lun =3D %d"=0A=
+			"isr get command error done, but got unknown"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#1216: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1444:=0A=
+		pr_notice("arcmsr%d: isr get an illegal ccb"=0A=
+		"command done acb =3D 0x%p,"=0A=
=0A=
WARNING: line over 80 characters=0A=
#1286: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1570:=0A=
+				pmu->done_qbuffer[doneq_index & 0xFF].addressLow;=0A=
=0A=
WARNING: line over 80 characters=0A=
#1460: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1865:=0A=
+		pinbound_srb =3D (struct InBound_SRB *)&pmu->post_qbuffer[postq_index =
& 0xFF];=0A=
=0A=
WARNING: line over 80 characters=0A=
#1469: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1874:=0A=
+			pmu->postq_index =3D index_stripped ? (index_stripped | 0x4000) : =
index_stripped;=0A=
=0A=
WARNING: line over 80 characters=0A=
#1474: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1879:=0A=
+			pmu->postq_index =3D index_stripped ? index_stripped : =
(index_stripped | 0x4000);=0A=
=0A=
WARNING: quoted string split across lines=0A=
#1492: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1894:=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter"=0A=
+		"background rebulid' timeout\n"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#1510: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1908:=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter"=0A=
+		"background rebulid' timeout\n"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#1526: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1923:=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter"=0A=
+		"background rebulid' timeout\n"=0A=
=0A=
WARNING: line over 80 characters=0A=
#1606: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2006:=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2193: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3039:=0A=
 		pr_notice("arcmsr%d: wait 'get adapter firmware"=0A=
+		"miscellaneous data' timeout\n",=0A=
=0A=
WARNING: line over 80 characters=0A=
#2221: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3208:=0A=
+			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2229: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3216:=0A=
+		pr_notice("arcmsr%d: wait 'get adapter firmware"=0A=
+		"miscellaneous data' timeout\n", pACB->host->host_no);=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2247: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3234:=0A=
+	pr_notice("Areca RAID Controller%d: F/W %s &"=0A=
+	"Model %s\n",=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2364: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3339:=0A=
+		pr_notice("arcmsr%d: wait get adapter firmware"=0A=
+		"miscellaneous data timeout\n", acb->host->host_no);=0A=
=0A=
WARNING: labels should not be indented=0A=
#2463: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3620:=0A=
+	polling_hbaD_ccb_retry:=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2497: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3654:=0A=
+				pr_notice("arcmsr%d: scsi id =3D %d"=0A=
+				"lun =3D %d ccb =3D '0x%p' poll command"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2508: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3665:=0A=
+			pr_notice("arcmsr%d: polling an illegal"=0A=
+			"ccb command done ccb =3D '0x%p'"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2642: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3821:=0A=
+			pr_notice("arcmsr%d: 'set command Q"=0A=
+			"window' timeout\n", acb->host->host_no);=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2744: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4070:=0A=
+		pr_notice("arcmsr%d: wait 'start adapter"=0A=
+		"background rebulid' timeout\n", pACB->host->host_no);=0A=
=0A=
WARNING: labels should not be indented=0A=
#2831: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4447:=0A=
+			nap:=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2835: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4451:=0A=
+				pr_err("arcmsr%d: waiting for"=0A=
+				"hw bus reset return, retry=3D%d\n",=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2840: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4456:=0A=
+					pr_err("arcmsr%d:"=0A=
+					"waiting for hw bus reset return,"=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2863: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4479:=0A=
+			pr_err("arcmsr: scsi bus reset"=0A=
+			"eh returns with success\n");=0A=
=0A=
WARNING: quoted string split across lines=0A=
#2883: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:4512:=0A=
 	pr_notice("arcmsr%d: abort device command of"=0A=
+		"scsi id =3D %d lun =3D %d\n",=0A=
=0A=
ERROR: Missing Signed-off-by: line(s)=0A=
=0A=
total: 1 errors, 44 warnings, 2798 lines checked=0A=
=0A=
../patch4 has style problems, please review.=0A=
=0A=
If any of these errors are false positives, please report=0A=
them to the maintainer, see CHECKPATCH in MAINTAINERS.=0A=

------=_NextPart_000_0009_01CE0605.027D91F0--
