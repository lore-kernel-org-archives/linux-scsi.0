From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Spamming linux-kernel and linux-scsi by out-of-tree
	patches	(LIO)
Date: Mon, 26 Jan 2009 16:37:31 +0000
Message-ID: <1232987851.3248.29.camel@localhost.localdomain>
References: <497DB7D0.8000302@vlnb.net>
	 <1232984234.3248.18.camel@localhost.localdomain>
	 <497DDFF8.8070707@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50916 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470AbZAZQhh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 11:37:37 -0500
In-Reply-To: <497DDFF8.8070707@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2009-01-26 at 19:08 +0300, Vladislav Bolkhovitin wrote:
> James Bottomley, on 01/26/2009 06:37 PM wrote:
> > On Mon, 2009-01-26 at 16:17 +0300, Vladislav Bolkhovitin wrote:
> >> Nicholas,
> >>
> >> Could you stop spamming linux-kernel and linux-scsi mailing lists by 
> >> patches for your out-of-tree LIO project, please?
> >>
> >> Those mailing lists are intended for patches for in-kernel components 
> >> only, not for all out-of-tree projects, finding their ways into the 
> >> mainline. I don't see any reason why your project should be an 
> >> exception. Think, what a mess the kernel mailing lists would get, if all 
> >> out-of-tree projects started sending their patches to them?
> > 
> > Actually, out of tree projects trying to make their way upstream are
> > welcome to use the various linux- mailing lists to solicit feedback and
> > review.  This method was, for instance, how FCoE made it in.
> 
> Hmm, I might be wrong, but what I've seen that FCoE only at the 
> beginning used linux-scsi for its intermediate patches, then such 
> patches quickly went into FCoE internal development mailing list only. 
> Then only resulting patches intended for wide review and mainline 
> inclusion were sent to linux-scsi. This is how I thought it's usually 
> considered should be done and how all the projects I've seen so far did.

The only piece I think they didn't bother with was the target, mainly
because the only wanted the initator upstream.  But the principle is
still the same: projects trying to make their way upstream are welcome
to send patches.

> I wouldn't object if Nicholas does the same and send in linux-scsi and 
> linux-kernel a complete patchset, which we will review and discuss. But 
> he sends *intermediate* patches and this looks for me like a violation 
> of fundamental rules/intention of Linux kernel mailing lists, hence I 
> complain.

FCoE did the same thing.  Incremental patches are useful in showing
motion towards coding standards and kernel norms ... at least they gave
me the warm feeling that FCoE was heading in the right direction.

As long as the full code is in a repository somewhere anyone whose
curiosity is piqued by the patches can go and look there as well.

> So, should I understand your words that you agree if I also start 
> sending intermediate patches for SCST to linux-scsi/linux-kernel?

Certainly.

James


