From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 9/23]: SCST virtual disk backend handler
Date: Wed, 10 Dec 2008 21:43:20 +0300
Message-ID: <49400DC8.6050209@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56601 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbYLJSnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:43:20 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains the SCST virtual disk backend device handler. This
is an SCST device handler that allows to export local files or local
block devices as SCSI devices through the SCST target framework. This
handler has three modes:

  - FILEIO mode, which allows to use files on file systems or block 
devices as virtual remotely available SCSI disks or CDROMs with benefits 
of the Linux page cache.

  - BLOCKIO mode, which performs direct block IO with a block device, 
bypassing page-cache for all operations. This mode works ideally with 
high-end storage HBAs and for applications that either do not need 
caching between application and disk or need the large block throughput.

  - NULLIO mode, in which no real IO is performed. It is intended for 
performance testing.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/dev_handlers/scst_vdisk.c | 3540 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  1 file changed, 3540 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/scst_vdisk.diff



