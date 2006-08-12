From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [RFC] [PATCH 0/9] Removal of old scsi code
Date: Sat, 12 Aug 2006 23:01:49 +0200
Message-ID: <44DE41BD.4010203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:28050 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1422670AbWHLVBP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Aug 2006 17:01:15 -0400
Received: by nf-out-0910.google.com with SMTP id a4so1295188nfc
        for <linux-scsi@vger.kernel.org>; Sat, 12 Aug 2006 14:01:14 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Achim Leubner <achim_leubner@adaptec.com>, ipslinux@adaptec.com, GOTO Masanori <gotom@debian.or.jp>

This patch series removes old scsi code.

The patches are against latest -mm snapshot.

dpt/dpti_i2o.h  |   10 ----
gdth.c          |  118 --------------------------------------------------------
gdth.h          |   10 ----
gdth_proc.c     |   27 ------------
ips.c           |  104 -------------------------------------------------
ips.h           |   28 -------------
nsp32.c         |   75 +----------------------------------
nsp32.h         |   42 -------------------
pcmcia/nsp_cs.h |   66 -------------------------------
9 files changed, 5 insertions(+), 475 deletions(-)

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/wiki/)




