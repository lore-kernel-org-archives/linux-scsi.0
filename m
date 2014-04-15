From: Christoph Hellwig <hch@lst.de>
Subject: tgt infrastructure removal
Date: Tue, 15 Apr 2014 12:26:49 +0200
Message-ID: <1397557614-21243-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaDOKYt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2014 06:24:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

This removes the old tgt infrastructure that has never been used except for
the obsolete ibmvstgt hardware (for which a working scst and a never fully
working lio driver exists).  By it's intimate tie-in into the initiator
layer it gets massively in the way of improvements in the initiator, most
importantly the ongoing blk-mq conversion.

