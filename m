From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: LSI megasas and duplicate erroneous devices?
Date: Sat, 29 Aug 2015 21:37:20 -0600
Message-ID: <2624815.2Idxd8EQn0@balsa>
References: <10175493.TuJJp3Z7hI@balsa>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tomasu.net ([192.241.222.217]:51130 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194AbbH3DhX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Aug 2015 23:37:23 -0400
Received: from balsa.localnet (S0106000024ce8134.ed.shawcable.net [174.3.73.24])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: thomas@fjellstrom.ca)
	by mail.tomasu.net (Postfix) with ESMTPSA id 1250414ACCB
	for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2015 03:37:23 +0000 (UTC)
In-Reply-To: <10175493.TuJJp3Z7hI@balsa>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sat 29 Aug 2015 09:00:44 AM Thomas Fjellstrom wrote:
> I'm seeing the strangest thing with my M1015/LSI card.
> 
> I'm getting regular DID_BAD_TARGET errors in the kernel log for a drive that
> was erroneously detected.
> 
> Inital detection looks like:
> 
> 
[snip]
> 
> 
> Note, this drive is a duplicate of either 0:0:13:0, or 0:0:16:0, there are
> only two WD Reds in this system. Two of the ports on the card are
> unpopulated.

*sigh* It appears there are actually three WD Reds in the system. So the 
problem isn't near as weird as i thought. I noticed the drive was actually 
visible a few minutes ago and it had a different S/N than the other WD's. I 
decided to take a look at the drives, and make sure all cables were seated 
properly, and while i was in there i took a can of compressed air to the 
entire box. Upon boot the drive was detected immediately, and so far hasn't 
dropped off, but it never dropped right away, so we'll see what happens. I'm 
running `badblocks -w` on it to see if it encounters any errors at all. If 
theres no errors, It'll go back into service as a spare in a raid6 array.

I've had to mess with that system so many times the past year I forgot I ended 
up putting three new WD's in there after a few Seagate's failed. 

So there we go. Nothing here unless it drops out again. I apologize for the 
noise.

[snip]
> 
> What exactly can cause this, and how can I fix it?

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
