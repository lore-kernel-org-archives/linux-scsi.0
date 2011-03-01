From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/5] target updates for scsi-post-merge .39 (round one,
	v2)
Date: Mon, 28 Feb 2011 16:33:05 -0800
Message-ID: <1298939585.5401.270.camel@haakon2.linux-iscsi.org>
References: <1298938651-18784-1-git-send-email-nab@linux-iscsi.org>
	 <1298938784.2487.72.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1298938784.2487.72.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Joel Becker <jlbec@evilplan.org>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-02-28 at 18:19 -0600, James Bottomley wrote:
> On Mon, 2011-02-28 at 16:17 -0800, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi James and Co,
> > 
> > The following is the first round (v2) of target patches intended for .39
> > scsi-post-merge tree that introduces new target functionality and the
> > first mainline TCM fabric module (TCM_Loop).
> 
> OK, what postmerge tree?  There haven't been any conflicts this merge
> cycle that necessitate running one.  Do you mean you want these after
> the merge window for some reason?
> 

Not really.  What I meant here is that this series needs to be applied
after the original 14 part series 'for .39 scsi-misc' fixes held over
for .38..

I was not sure if scsi-misc was for fixes only now, and if new target
code (like this series) should be going into scsi-post-merge or what..
So it sounds like this series for configfs statistics infrastructure and
initial TCM_Loop merge should be going through scsi-misc as well for
mainline .39, yes..?

Also, just another heads up in TCM fabric module land.  At this point in
lio-core-2.6.git/lio-4.1, drivers/target/iscsi/ has been fully converted
to use mainline libiscsi -> include/scsi/iscsi_proto.h definitions with
a few small additions/corrections.  This also includes a new set of
iSCSI fabric dependent ConfigFS statistics groups, and include the
removal of legacy ProcFS code from iscsi_target_mod.

The full iscsi_target_mod series will be posted in the next days for
review and comments.

Best Regards,

--nab
