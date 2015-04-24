From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [PATCH RESEND 0/4] bfa: Patches for scsi "misc" branch
Date: Fri, 24 Apr 2015 05:46:08 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF5901006752@avmb2.qlogic.org>
References: <1422953103-5470-1-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_20B1A3CBD98F3845B3F5F56D8597EF5901006752avmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:40586 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754607AbbDXFqM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2015 01:46:12 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id t3O5iVAq032133
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2015 22:46:11 -0700
Received: from avcashub1.qlogic.com (avcashub3.qlogic.com [198.70.193.117])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1tv76senh9-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2015 22:46:10 -0700
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "Jej B (James.Bottomley@hansenpartnership.com)" <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--_000_20B1A3CBD98F3845B3F5F56D8597EF5901006752avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Could I get a review for this patch series?

Thanks,
Anil

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of anil.gurumurthy@qlogic.com
Sent: 03 February 2015 14:15
To: James.Bottomley@HansenPartnership.com; hch@infradead.org
Cc: linux-scsi
Subject: [PATCH RESEND 0/4] bfa: Patches for scsi "misc" branch

Hi James, Christoph,

Re-sending the patches to move user visible strings to a separate patch.
Please apply the following patches to the scsi tree, misc branch  at your e=
arliest convenience.

Thanks,
Anil

Anil Gurumurthy (4):
  bfa:Updating copyright messages
  bfa:Fix for crash when bfa_itnim is NULL
  bfa:File header and user visible string changes
  bfa:Update driver version to 3.2.25.0

 drivers/scsi/bfa/bfa.h           |    7 ++--
 drivers/scsi/bfa/bfa_core.c      |    7 ++--
 drivers/scsi/bfa/bfa_cs.h        |    7 ++--
 drivers/scsi/bfa/bfa_defs.h      |    7 ++--
 drivers/scsi/bfa/bfa_defs_fcs.h  |    7 ++--
 drivers/scsi/bfa/bfa_defs_svc.h  |    7 ++--
 drivers/scsi/bfa/bfa_fc.h        |    7 ++--
 drivers/scsi/bfa/bfa_fcbuild.c   |    7 ++--
 drivers/scsi/bfa/bfa_fcbuild.h   |    7 ++--
 drivers/scsi/bfa/bfa_fcpim.c     |    7 ++--
 drivers/scsi/bfa/bfa_fcpim.h     |    7 ++--
 drivers/scsi/bfa/bfa_fcs.c       |    7 ++--
 drivers/scsi/bfa/bfa_fcs.h       |    9 +++--
 drivers/scsi/bfa/bfa_fcs_fcpim.c |    7 ++--
 drivers/scsi/bfa/bfa_fcs_lport.c |    9 +++--
 drivers/scsi/bfa/bfa_fcs_rport.c |    7 ++--
 drivers/scsi/bfa/bfa_hw_cb.c     |    7 ++--
 drivers/scsi/bfa/bfa_hw_ct.c     |    7 ++--
 drivers/scsi/bfa/bfa_ioc.c       |    9 +++--
 drivers/scsi/bfa/bfa_ioc.h       |    7 ++--
 drivers/scsi/bfa/bfa_ioc_cb.c    |    7 ++--
 drivers/scsi/bfa/bfa_ioc_ct.c    |    7 ++--
 drivers/scsi/bfa/bfa_modules.h   |    7 ++--
 drivers/scsi/bfa/bfa_plog.h      |    7 ++--
 drivers/scsi/bfa/bfa_port.c      |    7 ++--
 drivers/scsi/bfa/bfa_port.h      |    7 ++--
 drivers/scsi/bfa/bfa_svc.c       |    7 ++--
 drivers/scsi/bfa/bfa_svc.h       |    7 ++--
 drivers/scsi/bfa/bfad.c          |   24 +++++-------
 drivers/scsi/bfa/bfad_attr.c     |   75 +++++++++++++++++++---------------=
----
 drivers/scsi/bfa/bfad_bsg.c      |    7 ++--
 drivers/scsi/bfa/bfad_bsg.h      |    7 ++--
 drivers/scsi/bfa/bfad_debugfs.c  |    7 ++--
 drivers/scsi/bfa/bfad_drv.h      |    9 +++--
 drivers/scsi/bfa/bfad_im.c       |   35 ++++++++++++++++--
 drivers/scsi/bfa/bfad_im.h       |    7 ++--
 drivers/scsi/bfa/bfi.h           |    7 ++--
 drivers/scsi/bfa/bfi_ms.h        |    7 ++--
 drivers/scsi/bfa/bfi_reg.h       |    9 +++--
 39 files changed, 228 insertions(+), 168 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in th=
e body of a message to majordomo@vger.kernel.org More majordomo info at  ht=
tp://vger.kernel.org/majordomo-info.html

--_000_20B1A3CBD98F3845B3F5F56D8597EF5901006752avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
ACAAAABBAG4AaQBsACAARwB1AHIAdQBtAHUAcgB0AGgAeQAAAB8AZQABAAAANgAAAEEAbgBpAGwA
LgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwBkAAEAAAAK
AAAAUwBNAFQAUAAAAAAAAgFBAAEAAAB4AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAQQBuAGkA
bAAgAEcAdQByAHUAbQB1AHIAdABoAHkAAABTAE0AVABQAAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1
AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwACXQEAAAA2AAAAQQBuAGkAbAAuAEcA
dQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfAOVfAQAAAD4AAABz
AGkAcAA6AGEAbgBpAGwALgBnAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBjAG8A
bQAAAAAAHwAaDAEAAAAgAAAAQQBuAGkAbAAgAEcAdQByAHUAbQB1AHIAdABoAHkAAAAfAB8MAQAA
ADYAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0A
AAAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwBAAAAeAAAAAAAAACBKx+kvqMQGZ1uAN0B
D1QCAAAAgEEAbgBpAGwAIABHAHUAcgB1AG0AdQByAHQAaAB5AAAAUwBNAFQAUAAAAEEAbgBpAGwA
LgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAV0BAAAANgAA
AEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAA
HwD4PwEAAAAgAAAAQQBuAGkAbAAgAEcAdQByAHUAbQB1AHIAdABoAHkAAAAfACNAAQAAADYAAABB
AG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8A
IkABAAAACgAAAFMATQBUAFAAAAAAAAIB+T8BAAAAeAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAA
gEEAbgBpAGwAIABHAHUAcgB1AG0AdQByAHQAaAB5AAAAUwBNAFQAUAAAAEEAbgBpAGwALgBHAHUA
cgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8ACV0BAAAANgAAAEEAbgBp
AGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAxQAEA
AAACAAAAAAAAAAsAQDoBAAAAHwAwQAEAAAACAAAAAAAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBv
AHQAZQAAAAAAAwDxPwkEAAALAEA6AQAAAAMA/T/kBAAAAgELMAEAAAAQAAAAx/YaM8E84U6e0+Nr
N538xAMAFwABAAAAQAA5AACQGPZRftABQAAIMJIxG/ZRftABCwApAAAAAAALACMAAAAAAB8AAICG
AwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEA
AAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAABoUAAAAAAAAfADcAAQAA
AHYAAABSAEUAOgAgAFsAUABBAFQAQwBIACAAUgBFAFMARQBOAEQAIAAwAC8ANABdACAAYgBmAGEA
OgAgAFAAYQB0AGMAaABlAHMAIABmAG8AcgAgAHMAYwBzAGkAIAAiAG0AaQBzAGMAIgAgAGIAcgBh
AG4AYwBoAAAAAAAfAD0AAQAAAAoAAABSAEUAOgAgAAAAAAADADYAAAAAAAMALgAAAAAAHwBCEAEA
AAACAAAAAAAAAAIBcQABAAAAIAAAAAEB0D+TOPI9K3un4BxKgVCBtisa8BOdFus1sIBFM1ewHwBw
AAEAAABuAAAAWwBQAEEAVABDAEgAIABSAEUAUwBFAE4ARAAgADAALwA0AF0AIABiAGYAYQA6ACAA
UABhAHQAYwBoAGUAcwAgAGYAbwByACAAcwBjAHMAaQAgACIAbQBpAHMAYwAiACAAYgByAGEAbgBj
AGgAAAAAAB8ANRABAAAAeAAAADwAMgAwAEIAMQBBADMAQwBCAEQAOQA4AEYAMwA4ADQANQBCADMA
RgA1AEYANQA2AEQAOAA1ADkANwBFAEYANQA5ADAAMQAwADAANgA3ADUAMgBAAGEAdgBtAGIAMgAu
AHEAbABvAGcAaQBjAC4AbwByAGcAPgAAAB8AORABAAAAfgAAADwAMQA0ADIAMgA5ADUAMwAxADAA
MwAtADUANAA3ADAALQAxAC0AZwBpAHQALQBzAGUAbgBkAC0AZQBtAGEAaQBsAC0AYQBuAGkAbAAu
AGcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAD4AIAAAAAAAAwDeP59O
AAALAACACCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAA
AAGFAAAAAAAAAwCAEP////9AAAcwMjYO9VF+0AELAAIAAQAAAAMAJgAAAAAACwArAAAAAAACAUcA
AQAAAC4AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIyLTE1MDQyNDA1NDYwOFotOTM1ODMAAAAC
ARAwAQAAAEYAAAAAAAAApfa6WPiUnECXquZDOkRWvwcAILGjy9mPOEWz9fVthZfvWQAAAPSNGAAA
ZwQxjMtxokilXd7HughfeQBLeqYupAAAAAAfAPo/AQAAACAAAABBAG4AaQBsACAARwB1AHIAdQBt
AHUAcgB0AGgAeQAAAAMACVkBAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAEIUAAAAAAAALAACA
CCAGAAAAAADAAAAAAAAARgAAAAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiFAAAA
AAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAgoUAAAAAAABAAACACCAGAAAAAADAAAAAAAAARgAA
AAC/hQAA8ERuTk9+0AEfAACACCAGAAAAAADAAAAAAAAARgAAAADYhQAAAQAAABIAAABJAFAATQAu
AE4AbwB0AGUAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMA
LQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYB
AAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAYAAAAWwAxADAA
LgAxAC4ANAAuADEAMABdAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAFgAAAGQAaQBzAGMAbABh
AGkAbQBlAHIAAAAAAAEAAAAOAAAAYgB5AHAAYQBzAHMAAAAAACzg

--_000_20B1A3CBD98F3845B3F5F56D8597EF5901006752avmb2qlogicorg_--
