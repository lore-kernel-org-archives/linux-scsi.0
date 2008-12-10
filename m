From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 17/23]: InfiniBand SRP target driver
Date: Wed, 10 Dec 2008 21:55:39 +0300
Message-ID: <494010AB.5030304@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:58068 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbYLJSzb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:55:31 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Vu Pham <huongvp@yahoo.com>, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains target mode driver for InfiniBand SRP.

This driver work directly on top of InfiniBand stack and SCST.

Signed-off-by: Vu Pham <vu@mellanox.com>
Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/srpt/Kconfig     |   12
  drivers/scst/srpt/Makefile    |    4
  drivers/scst/srpt/ib_dm_mad.h |  106 ++
  drivers/scst/srpt/ib_srpt.c   | 2307 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/scst/srpt/ib_srpt.h   |  201 +++++
  5 files changed, 2630 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/srpt.diff



