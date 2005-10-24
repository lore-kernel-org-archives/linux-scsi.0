From: Jeff Garzik <jgarzik@pobox.com>
Subject: git tree for HCIL work: scsilun-2.6.git
Date: Mon, 24 Oct 2005 14:07:49 -0400
Message-ID: <435D22F5.6020401@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:56521 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751212AbVJXSH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 14:07:56 -0400
Received: from cpe-069-134-188-146.nc.res.rr.com ([69.134.188.146] helo=[10.10.10.88])
	by mail.dvmed.net with esmtpsa (Exim 4.52 #1 (Red Hat Linux))
	id 1EU6jg-0001NZ-7K
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 18:07:53 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

I've been committing all these "[PATCH RFC]" patches to a git repository 
locally.  I just stuck it on kernel.org, so that others can easily take 
a look at the end result:

rsync://rsync.kernel.org/pub/scm/linux/kernel/git/jgarzik/scsilun-2.6.git

This is PURELY EXPERIMENTAL code with NOT FOR UPSTREAM stuff in it. 
Bits will be extracted and sent upstream once they are ready.

The repo is mirroring out to *.kernel.org now, so give it a while before 
cloning.  kernel.org mirrors are slow these days, sometimes on the order 
of an hour or more.

