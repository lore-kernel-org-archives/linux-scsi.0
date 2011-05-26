From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v5 00/13] iscsi-target: initial .40-rc1 merge
Date: Wed, 25 May 2011 19:34:41 -0700
Message-ID: <1306377281.5807.89.camel@haakon2.linux-iscsi.org>
References: <1305862678-30150-1-git-send-email-nab@linux-iscsi.org>
	 <1306217216.29724.144.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1306217216.29724.144.camel@haakon2.linux-iscsi.org>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>, Stephen Rothwell <sfr@canb.auug.org.au>, Randy Dunlap <randy.dunlap@oracle.com>, linux-next <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-05-23 at 23:06 -0700, Nicholas A. Bellinger wrote:
> On Thu, 2011-05-19 at 20:37 -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi James,
> > 
> > Here is an updated v5 mergeable + squashable .40-rc1 series of iscsi-target
> > against scsi-misc .39-rc7 target core intrastructure with (round 1) .40
> > target core patches from this evening applied:
> > 

Hi James,

Just a heads up that this patch was sent out to the list here:

[PATCH] iscsi-target: Fix SessionType=Discovery RX context conn->conn_logout_comp hang
http://marc.info/?l=linux-scsi&m=130637348407180&w=2

This now puts the PATCH-v5 series in sync wrt to bugfixes for LIO
upstream iscsi-target v4.1 code..

More comments below..

> > As before, please merge patch #1 + #2 as seperate libiscsi commits with
> > Mike's signoff.  From there go ahead and squash #3 -> #13 using the commit
> > message of patch #3 for an initial commit of drivers/target/iscsi/
> > 
> > This patch has been made against the latest scsi-misc HEAD:
> > 
> > commit 6ad11eaa8a689a27e0c99905bcf800a37cd432a0
> > Author: Joe Carnuccio <joe.carnuccio@qlogic.com>
> > Date:   Tue May 10 11:30:16 2011 -0700
> > 
> >     [SCSI] qla2xxx: Refactor call to qla2xxx_read_sfp for thermal temperature.
> > 
> > 
> > The complete series for an initial merge including (round 1) .40 changes is
> > available directly here:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-40-iscsi-target-merge-v3
> > 
> > 
> > At this point there is one outstanding bug + patch being tested by Martin wrt
> > to SessionType=Discovery logout exception handling during an iscsi-target
> > failure/shutdown event.  Please expect an rc-fixes patch to address this
> > specific issue after the initial merge.
> > 
> > Thanks folks!
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > 
> 

<SNIP>

> I have no further changes nor gotten any further review feedback at this
> point for an initial merge for .40-rc1 (or 2.8.0-rc1) , and one
> iscsi-target bugfix is currently in my queue for rc-fixes that has been
> resolved recently with Martin's help.
> 
> Considering the short term window this time around, can you please have
> a look at getting this merged ASAP so that it can send a few days in
> linux-next..?
> 

There have been no further review comments for an initial merge, and we
are ready to move forward.  :)

So at this point I think providing the three 'mass-market' software
fabric drivers (tcm_loop, tcm_fc and iscsi-target) makes the most sense
for mainline .40 / 2.8.0 moving forward, and focus on outstanding HW
target driver items for the next merge window.

I know things are still very busy on your side with /drivers/scsi/ code,
but wanted to ensure that iscsi-target is still included for this short
merge window considering the extensive amount of linux-scsi review, code
conversion + cleanups, and testing it has undergone in the last 6 months
since the mainline drivers/target/ merge.

Please let me know if you need anything else to get this merged
scsi-misc, or if it makes more sense given the time pressures to ask
Linus (CC'ed) to merge this directly with appropriate Signed-off-bys
from Christoph, Mike, Tomo-san, Dr. Hannes, Boaz and yourself..

I am happy either way, but just want to avoid having this slip (again)
given the large amount of efforts involved and mass market applicability
of this particular target fabric code.

--nab
