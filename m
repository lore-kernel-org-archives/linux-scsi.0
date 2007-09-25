From: Matthew Wilcox <willy@linux.intel.com>
Subject: Remove ->done from scsi_cmnd
Date: Tue, 25 Sep 2007 12:42:00 -0400
Message-ID: <1190738524460-git-send-email-willy@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:44156 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbXIYQmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 12:42:07 -0400
Received: from ottawa-hs-64-26-147-37.d-ip.magma.ca ([64.26.147.37] helo=teeth.int.wil.cx)
	by mail-05.primus.ca with esmtp (Exim 4.63)
	(envelope-from <willy@wil.cx>)
	id 1IaDTl-0000U5-2J
	for linux-scsi@vger.kernel.org; Tue, 25 Sep 2007 12:41:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This series of four patches gets rid of ->done from scsi_cmnd.  It applies
on top of the patch I sent earlier today to improve gdth's abuse of
scsi_done.  Sorry, Boaz.  I'd like to thank Christoph for talking me
through some of the bits of the block layer I didn't grok.
