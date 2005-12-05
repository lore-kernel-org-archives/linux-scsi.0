From: Michael Reed <mdr@sgi.com>
Subject: Re: 2.6.15-rc4 error messages with multiple qla2300 hba ports on
 fabric
Date: Mon, 05 Dec 2005 13:06:26 -0600
Message-ID: <43948FB2.5070902@sgi.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B8D@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:54678 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751432AbVLETIz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2005 14:08:55 -0500
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B8D@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, hch@lst.de



James.Smart@Emulex.Com wrote:
> We recently saw this as well. It's related to the number of targets
> that go away simultaneously.
> 
> There ends up being many delete rport items on the work queue, and 
> when the 1st one stalls to flush the work queues, it starts the 2nd,
> which stops to flush, and so on.
> 
> My inclination is to look at what we have on the work queue and see if we can
> circumvent some of the flush calls.

Snooping the work queue?  That sounds a little, um, like a hack?
If the code is correct, and the end result is correct, is the
test for recursion level and the associated dump_stack() necessary?
(Yeah, I know, newbie questions. :)


Mike

...snip...

