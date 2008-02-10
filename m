From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] scsi_error: Fix language abuse.
Date: Sun, 10 Feb 2008 16:47:23 -0700
Message-ID: <20080210234722.GI5299@parisc-linux.org>
References: <20080208153217.5fc42a50@core> <47AD02C6.70402@torque.net> <20080209135020.6eca03ac@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42018 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYBJXrY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Feb 2008 18:47:24 -0500
Content-Disposition: inline
In-Reply-To: <20080209135020.6eca03ac@core>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dougg@torque.net, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 01:50:20PM +0000, Alan Cox wrote:
> On Fri, 08 Feb 2008 20:32:54 -0500 Douglas Gilbert <dougg@torque.net> wrote:
> > Alan Cox wrote:
> > > The word "illegal" has a precise dictionary meaning of "prohibited by
> > > law". 
> > 
> > Also "contrary to or forbidden by official rules, regulations, etc".
> 
> The OED I have here doesn't seem to think so, however if the words are
> the ones used in the T10 documentation then I'm happy to drop the patch.

Not everyone believes in the OED's definitions.  I prefer Chambers (in
general), which has the (online) definition:

illegal adj
1 against the law; not legal. Also called unlawful.
2 not authorized by law or by specific rules which apply.
ETYMOLOGY: 17c: from Latin illegalis.

I believe the second definition would apply here.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
