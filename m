From: Jeff Garzik <jgarzik@pobox.com>
Subject: SAS tree opened
Date: Tue, 18 Oct 2005 12:51:58 -0400
Message-ID: <4355282E.8030207@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:8344 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751010AbVJRQwA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Oct 2005 12:52:00 -0400
Received: from cpe-069-134-188-146.nc.res.rr.com ([69.134.188.146] helo=[10.10.10.88])
	by mail.dvmed.net with esmtpsa (Exim 4.52 #1 (Red Hat Linux))
	id 1ERugx-0004th-Pw
	for linux-scsi@vger.kernel.org; Tue, 18 Oct 2005 16:52:00 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


I opened a repository at
rsync://rsync.kernel.org/pub/scm/linux/kernel/git/jgarzik/sas-2.6.git

At the moment, it merely contains a copy of Adaptec's aic94xx driver and 
SAS code, without modification.

This week I'll start posting patches that move along the outline 
described in "Adaptec SAS integration notes" thread.

The main idea of this tree is to reconcile Adaptec SAS with upstream 
SCSI, with the intention of getting Adaptec 94xx + SAS software stack 
into the upstream kernel.

Contributions are of course welcomed.

	Jeff



