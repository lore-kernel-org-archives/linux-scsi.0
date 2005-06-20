From: "Ross Macintyre" <raz@macs.hw.ac.uk>
Subject: adaptec 2120S raid card: starting a verify using a cron job
Date: Mon, 20 Jun 2005 17:00:39 +0100 (BST)
Message-ID: <4017.137.195.14.2.1119283239.squirrel@www.macs.hw.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from izanagi.macs.hw.ac.uk ([137.195.13.5]:41197 "EHLO
	izanagi.macs.hw.ac.uk") by vger.kernel.org with ESMTP
	id S261327AbVFTQAk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 12:00:40 -0400
Received: from buddha.macs.hw.ac.uk ([137.195.13.48] ident=exim)
	by izanagi.macs.hw.ac.uk with esmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.34)
	id 1DkOhU-0003bx-3r
	for linux-scsi@vger.kernel.org; Mon, 20 Jun 2005 17:00:40 +0100
Received: from localhost
	([127.0.0.1] helo=www.macs.hw.ac.uk ident=www)
	by buddha.macs.hw.ac.uk with esmtp (Exim 4.34)
	id 1DkOhT-0004dX-Ol
	for linux-scsi@vger.kernel.org; Mon, 20 Jun 2005 17:00:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Can someone tell me how to start (or schedule) a verify (with fix)
of a RAID sytem - Adaptec 2120S, running RedHat.

I'm thinking along the lines of a cron job that does the following:
once a month, check that no verifys are running and none scheduled, and if
this is the case then start one.

I have looked at the aacli interface but it's not obvious to me what the
syntax should be.

I thought at first I would be able to set something up using the browser
interface but I see that that only lets me schedule it once and then it
has to be done all over again once it has run.
Either I'm missing something or this is a design fault - yeah more likely
the former!
Thanks in advance,

Ross Macintyre


-- 
Ross Macintyre (raz@macs.hw.ac.uk)

