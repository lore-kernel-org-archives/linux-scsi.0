From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 0/5] SCSI/initio fixes, cleanups, PCI API support
Date: Sun, 27 May 2007 10:52:00 -0400
Message-ID: <20070527145200.GA17017@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:33544 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbXE0OwD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 May 2007 10:52:03 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>


This patchset presents the path to PCI API support in the initio driver.

But the first patch really begs the question:  Has this driver really
been broken since Oct 2003?  If so, let's just delete it.

 drivers/scsi/initio.c |  206 +++++++++++++++++++++++++++++---------------------
 drivers/scsi/initio.h |   10 +-
 2 files changed, 127 insertions(+), 89 deletions(-)

