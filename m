From: Christoph Hellwig <hch@infradead.org>
Subject: status of drivers/scsi/scsi_tgt_lib.c
Date: Fri, 24 Jan 2014 05:15:25 -0800
Message-ID: <20140124131525.GA30922@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaAXNPb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2014 08:15:31 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

Hi Tomo-san,

what is the status of scsi_tgt_lib.c?  I've recently been auditing the
command allocation and I/O path for various possible improvements, and
the use of many functions in this path in addition to the normal
initiator code path is going to make a few things a bit harder.

The code seems to not have seen any major changes since about 2008,
and at least SRP hast another maintained target in mainline.

Do you know if either SRP or ibmvscsi are used regularly these days?
Does tgtd userspace still support this interface?
