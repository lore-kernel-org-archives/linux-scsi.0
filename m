From: Eugene Morozov <jmv-lists@linux-ink.ru>
Subject: JMR Fortra
Date: Tue, 23 Sep 2003 13:45:56 +0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030923094556.GA16412@linux-ink.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux-ink.lynx.ru ([195.9.178.133]:29702 "EHLO linux-ink.ru")
	by vger.kernel.org with ESMTP id S262745AbTIWJp6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 05:45:58 -0400
Received: from linux-ink.ru (localhost.localdomain [127.0.0.1])
	by linux-ink.ru (8.12.8/8.12.8) with ESMTP id h8N9juSV016443
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2003 13:45:56 +0400
Received: (from jmv@localhost)
	by linux-ink.ru (8.12.8/8.12.8/Submit) id h8N9juAL016441
	for linux-scsi@vger.kernel.org; Tue, 23 Sep 2003 13:45:56 +0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello!
One of our customers uses some JMR Fortra controller and complains
that it is not in the list of devices which can have non-zero LUNs. He
suggests adding the line
{"CNSi", "G6322", "*", BLIST_SPARSELUN}
to the file /usr/src/linux-2.4/drivers/scsi/scsi_scan.c (which he adds
with each distribution/kernel upgrade by hand). I can provide more
details if needed.
Eugene
