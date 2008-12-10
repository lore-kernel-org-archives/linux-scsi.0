From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 15/23]: QLogic target driver
Date: Wed, 10 Dec 2008 21:51:54 +0300
Message-ID: <49400FCA.7090805@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51324 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbYLJSwZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:52:25 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, linux-driver@qlogic.com, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains target mode add-on for qla2xxx driver for QLogic 
22xx/23xx cards.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/qla2xxx-target/Kconfig    |   19
  drivers/scst/qla2xxx-target/Makefile   |    6
  drivers/scst/qla2xxx-target/qla2x00t.c | 2280 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/scst/qla2xxx-target/qla2x00t.h |  163 ++++
  4 files changed, 2468 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/qla2x00t.diff



