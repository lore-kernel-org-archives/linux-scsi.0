From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 11:15:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068747355.16444.22.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131200420.949-100000@ida.rowland.org>
	 <1068744259.13580.41.camel@patrh9>
	 <20031113100424.A26197@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:31204 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264362AbTKMSQc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 13:16:32 -0500
In-Reply-To: <20031113100424.A26197@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, mdharm-scsi@one-eyed-alien.net, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> http://marc.theaimsgroup.com/?l=linux-scsi&m=106836761130746&w=2

Bingo!  Thank you.

> Showed the sequence:

Is this a CBI/CB trace?  That's not quite authentic Windows talk, as if
we had bInterfaceProtocol = x50 BBB with bInterfaceSubClass = x06
Transparent SCSI.  That's Windows opaquely filtered by the BCO
(binary-code-only) Windows CBI/CB driver.

> Showed the sequence:
> 
> 	INQUIRY length 0x24 (36) bytes
> 	READ CAPACITY
> 	TEST UNIT READY
> 	READ CAPACITY
> 	READ 10

Obsolete?

I see the comment says "win98".

I hear Win has two i/o traditions, binary incompatible.  I hear Win ME/
98SE/ etc. tries speech such as auto sense for x0E, whereas Win XP/2K
etc. tries such radically different speech as auto sense for x12.

When I choose to believe that rumour, I conclude Talk Like Massively
Distributed Consumer Windows in 2003 is Talk Like Win XP.

> Showed the sequence:
> 
> 	INQUIRY length 0x24 (36) bytes
> 	READ CAPACITY
> 	TEST UNIT READY
> 	READ CAPACITY
> 	READ 10

Did we omit auto sense from this trace?

I'm surprised to see no auto sense of unit attentions (x 6 29 Reset, x 6
28 GoneReady) early in life, after I see -i x24 -y "12 00:00:00 24 00"
// Inquiry report (!!(bytes[1] & x80 RMB)) i.e. disc removable without
removing drive.

Pat LaVarre


