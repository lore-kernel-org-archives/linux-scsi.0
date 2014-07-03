From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Should SATA port multipliers work with SAS drivers?
Date: Thu, 3 Jul 2014 12:32:04 +0900 (JST)
Message-ID: <63405.40469.qm@web100008.mail.kks.yahoo.co.jp>
Reply-To: Norman Diamond <n0diamond@yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100008.mail.kks.yahoo.co.jp ([114.111.98.182]:36429 "HELO
	web100008.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753512AbaGCDis convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jul 2014 23:38:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Am I dreaming, or was it formerly possible to view 20 SATA hard drives =
through 4 SATA port multipliers connected to 1 SAS board?
=A0
If it used to work, why did it stop working?=A0 Is this the reason:
[isci PATCH v2 15/18] libsas: drop sata port multiplier infrastructure
http://www.spinics.net/lists/linux-scsi/msg57986.html
=A0
Is there a possibility that it might start working again, or start work=
ing for the first time?
Re: [PATCH 0/3] libsas: add support for port multiplier
https://lkml.org/lkml/2014/5/2/350
=A0
CONFIG_SCSI_SAS_LIBSAS=3Dm
CONFIG_SCSI_SAS_HOST_SMP=3Dy
CONFIG_SCSI_MVSAS=3Dm
CONFIG_SCSI_MVSAS_DEBUG=3Dy
CONFIG_SCSI_MVSAS_TASKLET=3Dy
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
