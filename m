From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v4 00/12] iSCSI target v4.1.0-rc1 series for .39-rc1
Date: Mon, 21 Mar 2011 14:06:01 -0700
Message-ID: <1300741561.21880.22.camel@haakon2.linux-iscsi.org>
References: <1300613497-2091-1-git-send-email-nab@linux-iscsi.org>
	 <1300740867.21880.12.camel@haakon2.linux-iscsi.org>
	 <1300741629.10634.46.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35493 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab1CUVNO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 17:13:14 -0400
In-Reply-To: <1300741629.10634.46.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>, Jesper Juhl <jj@chaosbits.net>

On Mon, 2011-03-21 at 16:07 -0500, James Bottomley wrote:
> On Mon, 2011-03-21 at 13:54 -0700, Nicholas A. Bellinger wrote:
> > On Sun, 2011-03-20 at 02:31 -0700, Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > 
> > > Greetings all,
> > > 
> > > This is the forth RFC series of the RisingTide Systems iSCSI target fabric
> > > module compatible with mainline target core v4 -> for-39 target infrastructure.
> > > 
> > > More information about iscsi_target_mod is available here:
> > > 
> > > http://linux-iscsi.org/wiki/ISCSI/configFS
> > > 
> > > This series contains the updated drivers/target/iscsi/ source tree for modern
> > > mainline code based on feedback from Christoph Hellwig that has been recently
> > > pushed into the lio-core-2.6.git/lio-4.1 development branch.  This includes
> > > another round of iSCSI network portal changes to use proper Linux/Net code
> > > w/ IPv6/IPv4 iscsi_np->np_sockaddr, conversion of iSCSI TX thread context
> > > to use schedule_timeout_interruptible(), and the renaming the majority of
> > > functions to use the 'iscsit_*' function prefix based upon hch's feedback.
> > > 
> > > This series is currently rebased against .38-FINAL using target core v4.0.0-rc7-ml.
> > > 
> > > The full RFC-v4 series for iscsi-target is available here:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-iscsi-target-v4
> > > 

<SNIP>

> > > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > > 
> > 
> > Hi Christoph, James and Co,
> > 
> > At this point I have no further changes beyond RFC-v4 for the initial
> > merge of iscsi-target.  Please let me know if anything was missed from
> > your review for the above changes, and I will get any remaining items
> > addressed ASAP.
> 
> OK ... so if you're ready, you can send the next one as a patch not rfc.
> 

Ok, I will give 1-2 days for the final round of feedback on RFC-v4, and
post the next series as [PATCH].  Please let me know if this should
happen sooner in order not to miss the second round of SCSI patches
going to Linus this week.

> > Also James, how do you prefer this series be sent out for the initial
> > merge in order avoid the vger lists max character limit..?
> 
> I don't really care ... it's fairly easy to combine stuff.  It's nice if
> the first patch has the complete changelog ...
> 

Ok, so I will send out the 12 part series tagged as [PATCH], and will
include a full changelog in the first patch, intending for the rest of
the patches to be squashed into the first.

Thank you,

--nab

