From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 16:37:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068766632.2851.142.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:50664 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264458AbTKMXhp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 18:37:45 -0500
In-Reply-To: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

Alan S:

> basically just two issues:
> will the device carry out a write request, and
> will the kernel allow you to send a write request to the device.

Aye.

Ouch by now I've discard two drafts of line-by-line replies.

Perhaps first I should say, yes I have studied cdrom/ ide-cd/ sr here. 
Jens Axboe & friends have taught me how those work in a tangle of recent
linux-scsi threads now paused at "Re: [PATCH] CDC_WR".

Maybe here I mean to ask: can we easily nutshell for me how well
write-protect works now in sd?  I understand that we find mode sense of
header alone and mode sense of xFF troublesome.

I'm not clear how often we try those techniques.  Do we try only soon
after plug in or also soon after each disc insertion?

Tell me that much and maybe I can more concisely make the rest of my
confusion clear.

Pat LaVarre


