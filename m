From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: How to clear bogus WP bit?
Date: Fri, 4 Mar 2005 11:15:21 -0500
Message-ID: <200503041615.j24GFQ525223@www.watkins-home.com>
References: <Pine.LNX.4.44.0503041647420.25272-100000@notebook.home.mdiehl.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Received: from sccrmhc13.comcast.net ([204.127.202.64]:3740 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S262902AbVCDQPc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Mar 2005 11:15:32 -0500
In-Reply-To: <Pine.LNX.4.44.0503041647420.25272-100000@notebook.home.mdiehl.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Martin Diehl' <lists@mdiehl.de>, linux-scsi@vger.kernel.org

The card should have a switch.  Check the card again.  Maybe use a
magnifying glass.

Guy

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Martin Diehl
Sent: Friday, March 04, 2005 11:07 AM
To: linux-scsi@vger.kernel.org
Subject: How to clear bogus WP bit?


Hi,

my MMC flashcard used to work with my usb card reader right until a 
boot-crash of an embedded system while the card was in use there. Since 
then, both Linux and Windows report the card being write-protected. 
Reading still works without problems.

Note, on MMC-Cards there is no write-protect clip so I have no idea how it 
happened to become write protected and - even more important - how to 
unprotect it. I've already cheated the sd-driver to ignore the WP-bit so I 
can rw-mount again. However, when trying to write to the guy it returns 
command errors due to media protection still effective. So my current 
conclusion is somehow the MMC really managed to get into a write-protected 
state without any mechanical switch.

Any hints how to unprotect it? Is it possible somehow to clear the WP 
state by software? Or does this probably mean the MMC went south?

TIA
Martin

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

