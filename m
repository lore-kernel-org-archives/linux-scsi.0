From: Paul Wagland <paul@kungfoocoder.org>
Subject: Megaraid driver updates and kernel 2.6.2
Date: Thu, 12 Feb 2004 11:27:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076581679.1875.4533.camel@paulw-desktop.allshare.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out2.xs4all.nl ([194.109.24.12]:62725 "EHLO
	smtp-out2.xs4all.nl") by vger.kernel.org with ESMTP id S264300AbUBLK2M
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 05:28:12 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: atulm@lsil.com

Hi all,

I recently purchased myself a LSI MegaRAID SATA 6 card, and have so far
been relatively happy, with a few "minor" gripes. The primary gripe is
that the card will sometimes lock up under heavy load, while doing
background synchronisations/rebuilds.

As far as I understand, the LSI megaraid 2.00.4 driver includes changes
that should fix this problem[1], and the driver has been updated to
2.10.1 for the 2.4.x kernel.

Further, because of major structural changes in the 2.6.1 timeframe, it
is not easy to forward port the 2.10.1 driver to the 2.6.x kernel tree.
[2]

Anyway, I have been going through and trying to sort out some of these
changes, and am making some headway. My question, is how should I
present these patches? Should I just send it to this list (linux-scsi),
or should I just send them to LSI (Atul Mukker) and then get them to
forward the patches on when they are happy? Further, should I try to
"pull" the driver up through the versions, or just send through patches
for "logical" chunks in whatever order I get through them?

Or is someone else already working on this, and I don't need to
anything? :-)

Thanks for your inputs,
Paul Wagland

[1]
ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.10.1/changelog.megaraid2
[2] http://www.ussg.iu.edu/hypermail/linux/kernel/0401.1/1697.html

