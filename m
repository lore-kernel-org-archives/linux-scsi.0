From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 0/6] mpt fusion
Date: Sat, 29 Sep 2007 10:15:24 -0600
Message-ID: <20070929161524.GA4325@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:41868 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864AbXI2QPW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2007 12:15:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

I'm sending this set of patchs with hope they get into the 2.6.24 merge window. This applied over jejb scsi-misc tip.

1) adding usage of shost_priv and removing all the typecasting
2) Fixing sparse warnings
3) locking down ScsiLookup
4) fix up fusion prints using the sdev_printk, dev_printk, and shost_printk API
5) mptlan: bug fix, only half the message frame is dma'd resulting in corruption
6) -mm patch: shutup uninitialized variable warnings
