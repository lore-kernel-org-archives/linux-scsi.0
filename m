From: "Ross Macintyre" <raz@macs.hw.ac.uk>
Subject: getting mail notification working (Adaptec 2120S + RedHat)
Date: Mon, 7 Jun 2004 15:44:14 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2852.137.195.14.4.1086619454.squirrel@www.macs.hw.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from izanami.macs.hw.ac.uk ([137.195.13.6]:1961 "EHLO
	izanami.macs.hw.ac.uk") by vger.kernel.org with ESMTP
	id S264705AbUFGOoP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jun 2004 10:44:15 -0400
Received: from surya.macs.hw.ac.uk ([137.195.13.8])
	by izanami.macs.hw.ac.uk with esmtp (Exim 4.34)
	id 1BXLME-0003XU-K0
	for linux-scsi@vger.kernel.org; Mon, 07 Jun 2004 15:44:14 +0100
Received: from localhost ([127.0.0.1] helo=www.macs.hw.ac.uk)
	by surya.macs.hw.ac.uk with smtp (Exim 4.10)
	id 1BXLME-0005H0-00
	for linux-scsi@vger.kernel.org; Mon, 07 Jun 2004 15:44:14 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I hope someone can help.
I am trying to set up mail notification on a machine that has an
Adaptec 2120S card. This machine runs RedHat 8.0

Firstly, is there an easy way to test this rather than pull
a disk out and see if I get an email message or not? Saying that,
this is how I did test it and sure enough I didn't get a message.
I did check the log on my SMTP server though and I saw that my RAID
machine did try and connect but got this result:
(the mail server runs exim)

2004-06-04 15:01:53 SMTP protocol violation: synchronization error
(input sent without waiting for greeting): rejected connection
from H=buddha.macs.hw.ac.uk [137.195.24.3] U=root


Also, when I set it up originally, it doesn't seem to display
corectly when I run 'anotifyd -c'; like this is what happens:

<1013-52>buddha# ./anotifyd -c
Would you like to enable logging of events to your system log?y

You have currently selected:criticalwarningCritical error
messagesWarning messagesInformational messagesDoneToggle which
message type?4


I have just put the RPMs that come with the CD on to the system, but
maybe I should be getting the lastest RPMs and also the latest
firware upgrades.

Any feed back much appreciated.

Thanks in advance,

Ross



-- 
Ross Macintyre (raz@macs.hw.ac.uk)
