From: "Nicholas A. Bellinger" <nab@kernel.org>
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Date: Fri, 12 Dec 2008 01:40:09 -0800
Message-ID: <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>
	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
	 <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
Reply-To: nab@kernel.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:44203 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753018AbYLLJqw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 04:46:52 -0500
In-Reply-To: <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@hansenpartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Jens Axboe <jens.axboe@oracle.com>

On Fri, 2008-12-12 at 08:21 +0100, Bart Van Assche wrote:
> On Thu, Dec 11, 2008 at 8:58 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > On Thu, 2008-12-11 at 20:24 +0100, Bart Van Assche wrote:
> >> On Thu, Dec 11, 2008 at 4:14 AM, Nicholas A. Bellinger
> >> <nab@linux-iscsi.org> wrote:
> >> > Things are moving quickly for Target_Core_Mod/ConfigFS and LIO-Target
> >> > v3.0 development, and I invite folks to have a look at the code.  To
> >> > dive into the rest of the v3.0 code via git-web, check out:
> >> >
> >> > http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=tree;f=drivers/lio-core
> >>
> >> I didn't have a look at the LIO code, but I ran it through checkpatch.
> >> The result summary is as follows:
> >>
> > Thanks for the note, but checkpatch output on the entire tree (not just
> > the patchs I posted) does not really help the discussion.  Obviously
> > this is on my list before submission for Target_Core_Mod/ConfigFS for
> > v2.6.29.  However, what would be nice if you actually sent a kernel
> > patch for these issues.
> 
> I ran checkpatch on the files in drivers/lio-core ONLY. I did this by
> converting all the files in drivers/lio-core through a script into a
> patch, and by running checkpatch on the generated patch.
> 
> And as you already know I'm not going to work on LIO.
> 

Too bad, because you are missing out on the most advanced ConfigFS
enabled storage engine on the planet.

Best regards,

--nab

> Bart.
> 
> --~--~---------~--~----~------------~-------~--~----~
> You received this message because you are subscribed to the Google Groups "Linux-iSCSI.org Target Development" group.
> To post to this group, send email to linux-iscsi-target-dev@googlegroups.com
> To unsubscribe from this group, send email to linux-iscsi-target-dev+unsubscribe@googlegroups.com
> For more options, visit this group at http://groups.google.com/group/linux-iscsi-target-dev?hl=en
> -~----------~----~----~----~------~----~------~--~---
> 

