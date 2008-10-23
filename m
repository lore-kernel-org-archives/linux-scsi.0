From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Possible bug in SCSI Kconfig
Date: Thu, 23 Oct 2008 11:39:18 -0600
Message-ID: <20081023173917.GP26094@parisc-linux.org>
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com> <1224702340.6851.20.camel@localhost.localdomain> <b637ec0b0810221225q589ed071i75f559d6fa76d96b@mail.gmail.com> <1224704659.6851.28.camel@localhost.localdomain> <4900B4B9.4050103@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51989 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbYJWRjV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2008 13:39:21 -0400
Content-Disposition: inline
In-Reply-To: <4900B4B9.4050103@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Fabio Comolli <fabio.comolli@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, sam@ravnborg.org, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Oct 23, 2008 at 07:30:33PM +0200, Stefan Richter wrote:
>   - scsi_wait_scan is a special method to wait for devices during boot
>     which only works with some hardware types.  More general methods are
>     available and have been in use far longer than scsi_wait_scan
>     exists.  Nobody fundamentally needs scsi_wait_scan, it is only a
>     convenient tool for some users who choose to use it.
>     Special features are traditionally per default off in Kconfig and
>     are supposed to be actively enabled.

What 'general methods' would those be?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
