From: "Ross Macintyre" <raz@macs.hw.ac.uk>
Subject: monitoring Mylex AcceleRAID 170
Date: Wed, 4 Feb 2004 14:50:48 -0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3259.137.195.14.4.1075906248.squirrel@www.macs.hw.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from izanami.macs.hw.ac.uk ([137.195.13.6]:34231 "EHLO
	izanami.macs.hw.ac.uk") by vger.kernel.org with ESMTP
	id S261827AbUBDOuu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2004 09:50:50 -0500
Received: from surya
	([137.195.13.8] helo=surya.macs.hw.ac.uk ident=exim)
	by izanami.macs.hw.ac.uk with esmtp (Exim 4.20)
	id 1AoOMb-0007FY-2T
	for linux-scsi@vger.kernel.org; Wed, 04 Feb 2004 14:50:49 +0000
Received: from localhost
	([127.0.0.1] helo=www.macs.hw.ac.uk ident=www)
	by surya.macs.hw.ac.uk with smtp (Exim 4.10)
	id 1AoOMa-0003tT-00
	for linux-scsi@vger.kernel.org; Wed, 04 Feb 2004 14:50:48 +0000
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,
  can someone tell me how to setup the software to monitor a
Mylex AcceleRAID 170 PCI RAID Controller under RedHat 8.0?
A brief description would do fine thanks.

I already have a number of machines with the newer LSILogic
MegaRAID cards(SCSI 320-2) and they work fine using megamgr and
MegaServ/MegaCtrl.

I want to do the same for this older machine with the Mylex card and
on looking at the stuff at the LSI site I see that it seems to rely
mainly on using SNMP. Can I set it up to *not* use SNMP?
What do I need to install? There are 3 RPMs:
        gam-client-5.00-19 gam-server-5.00-17 gam-agent-5.00-17
Will I only need one and would that be gam-server?

What I would like to do is set thing up so that it does the
following:
1. sends mail on error conditions.
2. allow me to check the status of the configuration(run the
equivalent of megamgr for the MegaRAID card). But if there is
not an equivalent of megamgr, that would be ok, so long as
I could look at a log.

Well thanks in advance,
hope someone can save me a lot of guddling about,

Ross


-- 
Ross Macintyre (raz@macs.hw.ac.uk)
