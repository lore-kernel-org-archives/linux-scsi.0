From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: [PATCH 5/5]  arcmsr: Modify ARC-1214 Inband Messages Behavior
Date: Fri, 8 Feb 2013 14:03:13 +0800
Message-ID: <5741810F8C904659B2563B4E3058B701@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000C_01CE0605.0B4382E0"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jejb@kernel.org, ??? <ching2048@areca.com.tw>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_000C_01CE0605.0B4382E0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Nick Cheng <nick.cheng@areca.com.tw>

Modify ARC-1214 inband messages behavior to make up for HW seldom malfunction.
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
---

------=_NextPart_000_000C_01CE0605.0B4382E0
Content-Type: application/octet-stream;
	name="checkpatch5"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="checkpatch5"

WARNING: line over 80 characters=0A=
#26: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:86:=0A=
+			if ((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) >=3D 1032) {=0A=
=0A=
WARNING: line over 80 characters=0A=
#31: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:91:=0A=
+				if (((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) + =
acb->rqbuf_lastindex) > 1032) {=0A=
=0A=
WARNING: line over 80 characters=0A=
#32: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:92:=0A=
+					memcpy(ptmpQbuffer, pQbuffer, ARCMSR_MAX_QBUFFER - =
acb->rqbuf_firstindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#33: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:93:=0A=
+					ptmpQbuffer +=3D ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex;=0A=
=0A=
WARNING: line over 80 characters=0A=
#34: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:94:=0A=
+					memcpy(ptmpQbuffer, acb->rqbuffer, 1032 - (ARCMSR_MAX_QBUFFER - =
acb->rqbuf_firstindex));=0A=
=0A=
WARNING: line over 80 characters=0A=
#35: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:95:=0A=
+					acb->rqbuf_firstindex =3D 1032 - (ARCMSR_MAX_QBUFFER - =
acb->rqbuf_firstindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#38: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:98:=0A=
+					memcpy(ptmpQbuffer, pQbuffer, ARCMSR_MAX_QBUFFER - =
acb->rqbuf_firstindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#39: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:99:=0A=
+					ptmpQbuffer +=3D ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex;=0A=
=0A=
WARNING: line over 80 characters=0A=
#40: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:100:=0A=
+					memcpy(ptmpQbuffer, acb->rqbuffer, acb->rqbuf_lastindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#41: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:101:=0A=
+					allxfer_len =3D ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex + =
acb->rqbuf_lastindex;=0A=
=0A=
WARNING: line over 80 characters=0A=
#42: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:102:=0A=
+					acb->rqbuf_firstindex =3D acb->rqbuf_lastindex;=0A=
=0A=
WARNING: line over 80 characters=0A=
#46: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:106:=0A=
+			if ((acb->rqbuf_lastindex - acb->rqbuf_firstindex) > 1032) {=0A=
=0A=
WARNING: line over 80 characters=0A=
#51: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:111:=0A=
+				memcpy(ptmpQbuffer, pQbuffer, acb->rqbuf_lastindex - =
acb->rqbuf_firstindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#52: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:112:=0A=
+				allxfer_len =3D acb->rqbuf_lastindex - acb->rqbuf_firstindex;=0A=
=0A=
WARNING: line over 80 characters=0A=
#90: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:137:=0A=
+				memcpy(pQbuffer, temp, ARCMSR_MAX_QBUFFER - rqbuf_lastindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#92: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:139:=0A=
+				rqbuf_lastindex =3D (rqbuf_lastindex + data_len) % =
ARCMSR_MAX_QBUFFER;=0A=
=0A=
WARNING: line over 80 characters=0A=
#93: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:140:=0A=
+				memcpy(&acb->rqbuffer[0], temp, rqbuf_lastindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#96: FILE: drivers/scsi/arcmsr/arcmsr_attr.c:143:=0A=
+				rqbuf_lastindex =3D (rqbuf_lastindex + data_len) % =
ARCMSR_MAX_QBUFFER;=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#225: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:771:=0A=
+						} else if ((temp & 0x01) =3D=3D 0=0A=
=0A=
WARNING: line over 80 characters=0A=
#228: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:774:=0A=
+							scsi_device_lookup(acb->host,=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#230: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:776:=0A=
+							if (psdev !=3D NULL) {=0A=
=0A=
WARNING: line over 80 characters=0A=
#231: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:777:=0A=
+								scsi_remove_device(psdev);=0A=
=0A=
WARNING: line over 80 characters=0A=
#232: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:778:=0A=
+								scsi_device_put(psdev);=0A=
=0A=
WARNING: line over 80 characters=0A=
#328: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1549:=0A=
+			while ((doneq_index & 0xFFF) !=3D (outbound_write_pointer & 0xFFF)) {=0A=
=0A=
WARNING: line over 80 characters=0A=
#339: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1556:=0A=
+					(index_stripped | 0x4000) : (index_stripped + 1);=0A=
=0A=
WARNING: line over 80 characters=0A=
#349: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1563:=0A=
+					index_stripped ? index_stripped : ((index_stripped | 0x4000) + 1);=0A=
=0A=
WARNING: line over 80 characters=0A=
#354: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:1567:=0A=
+				pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;=0A=
=0A=
WARNING: braces {} are not necessary for single statement blocks=0A=
#420: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2145:=0A=
+			if (!vaddr) {=0A=
+				goto leave;=0A=
+			}=0A=
=0A=
WARNING: labels should not be indented=0A=
#460: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2183:=0A=
+	leave:=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#506: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2223:=0A=
+						if ((acb->wqbuf_lastindex=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#515: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2232:=0A=
+						} else {=0A=
=0A=
WARNING: line over 80 characters=0A=
#516: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2233:=0A=
+							memcpy(iop_data, pQbuffer,=0A=
=0A=
WARNING: line over 80 characters=0A=
#518: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2235:=0A=
+							- acb->wqbuf_firstindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#593: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2308:=0A=
+		arcmsr_iop_message_wrote(acb);/*notice IOP the message has been =
written*/=0A=
=0A=
WARNING: line over 80 characters=0A=
#646: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2495:=0A=
+				? (index_stripped | 0x4000) : (index_stripped + 1);=0A=
=0A=
WARNING: line over 80 characters=0A=
#654: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2501:=0A=
+				? index_stripped : ((index_stripped | 0x4000) + 1);=0A=
=0A=
WARNING: line over 80 characters=0A=
#727: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2728:=0A=
+						&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#728: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2729:=0A=
+						if (acb->wqbuf_firstindex + 4 >=0A=
=0A=
WARNING: line over 80 characters=0A=
#730: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2731:=0A=
+							memcpy(iop_data, pQbuffer,=0A=
=0A=
WARNING: line over 80 characters=0A=
#731: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2732:=0A=
+							ARCMSR_MAX_QBUFFER - acb->wqbuf_firstindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#732: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2733:=0A=
+							iop_data +=3D ARCMSR_MAX_QBUFFER=0A=
=0A=
WARNING: line over 80 characters=0A=
#734: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2735:=0A=
+							acb->wqbuf_firstindex +=3D 4;=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#742: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2743:=0A=
+						} else {=0A=
=0A=
WARNING: line over 80 characters=0A=
#743: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2744:=0A=
+							if ((acb->wqbuf_lastindex -=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#743: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2744:=0A=
+							if ((acb->wqbuf_lastindex -=0A=
=0A=
WARNING: line over 80 characters=0A=
#744: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2745:=0A=
+							acb->wqbuf_firstindex) > 4) {=0A=
=0A=
WARNING: line over 80 characters=0A=
#747: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2748:=0A=
+								acb->wqbuf_firstindex=0A=
=0A=
WARNING: line over 80 characters=0A=
#749: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2750:=0A=
+								acb->wqbuf_firstindex=0A=
=0A=
WARNING: line over 80 characters=0A=
#750: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2751:=0A=
+								%=3D ARCMSR_MAX_QBUFFER;=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#752: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2753:=0A=
+							} else {=0A=
=0A=
WARNING: line over 80 characters=0A=
#755: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2756:=0A=
+								acb->wqbuf_lastindex=0A=
=0A=
WARNING: line over 80 characters=0A=
#756: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2757:=0A=
+								- acb->wqbuf_firstindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#758: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2759:=0A=
+								acb->wqbuf_lastindex=0A=
=0A=
WARNING: line over 80 characters=0A=
#759: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2760:=0A=
+								- acb->wqbuf_firstindex;=0A=
=0A=
WARNING: line over 80 characters=0A=
#760: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2761:=0A=
+								acb->wqbuf_firstindex=0A=
=0A=
WARNING: line over 80 characters=0A=
#761: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2762:=0A=
+								=3D acb->wqbuf_lastindex;=0A=
=0A=
WARNING: line over 80 characters=0A=
#782: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2783:=0A=
+						&acb->wqbuffer[acb->wqbuf_firstindex];=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#783: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2784:=0A=
+						if ((acb->wqbuf_lastindex -=0A=
=0A=
WARNING: Too many leading tabs - consider code refactoring=0A=
#792: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2793:=0A=
+						} else {=0A=
=0A=
WARNING: line over 80 characters=0A=
#793: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2794:=0A=
+							memcpy(iop_data, pQbuffer,=0A=
=0A=
WARNING: line over 80 characters=0A=
#795: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2796:=0A=
+							- acb->wqbuf_firstindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#825: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2826:=0A=
+						allxfer_len +=3D acb->wqbuf_lastindex=0A=
=0A=
WARNING: printk() should include KERN_ facility level=0A=
#874: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2867:=0A=
+		printk("%s: ARCMSR_MESSAGE_FAIL!\n", __func__);=0A=
=0A=
WARNING: printk() should include KERN_ facility level=0A=
#890: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2879:=0A=
+			printk("%s: memory not enough!\n", __func__);=0A=
=0A=
WARNING: line over 80 characters=0A=
#953: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2935:=0A=
+					acb->rqbuf_lastindex - acb->rqbuf_firstindex);=0A=
=0A=
WARNING: line over 80 characters=0A=
#982: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2950:=0A=
+			data_len_residual =3D data_len =3D readl(&prbuffer->data_len);=0A=
=0A=
WARNING: braces {} are not necessary for single statement blocks=0A=
#985: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2953:=0A=
+				if (!vaddr) {=0A=
+					goto leave;=0A=
+				}=0A=
=0A=
WARNING: labels should not be indented=0A=
#1025: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2992:=0A=
+		leave:=0A=
=0A=
WARNING: line over 80 characters=0A=
#1029: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:2994:=0A=
+		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);=0A=
=0A=
WARNING: line over 80 characters=0A=
#1093: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3046:=0A=
+					pQbuffer =3D &acb->wqbuffer[acb->wqbuf_lastindex];=0A=
=0A=
WARNING: line over 80 characters=0A=
#1099: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3052:=0A=
+						ptmpuserbuffer +=3D (ARCMSR_MAX_QBUFFER=0A=
=0A=
WARNING: line over 80 characters=0A=
#1107: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3060:=0A=
+						acb->wqbuf_lastindex +=3D user_len;=0A=
=0A=
WARNING: printk() should include KERN_ facility level=0A=
#1282: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3210:=0A=
+		printk("unknown controlcode(%d)\n", __LINE__);=0A=
=0A=
WARNING: line over 80 characters=0A=
#1354: FILE: drivers/scsi/arcmsr/arcmsr_hba.c:3957:=0A=
+			pmu->doneq_index =3D index_stripped ? (index_stripped | 0x4000)=0A=
=0A=
ERROR: Missing Signed-off-by: line(s)=0A=
=0A=
total: 1 errors, 74 warnings, 1349 lines checked=0A=
=0A=
../patch5 has style problems, please review.=0A=
=0A=
If any of these errors are false positives, please report=0A=
them to the maintainer, see CHECKPATCH in MAINTAINERS.=0A=

------=_NextPart_000_000C_01CE0605.0B4382E0--
