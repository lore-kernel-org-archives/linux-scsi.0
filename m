From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL for 38-rc3]  target updates for v4.0.0-rc7
Date: Mon, 24 Jan 2011 17:27:51 -0800
Message-ID: <1295918871.24778.161.camel@haakon2.linux-iscsi.org>
References: <1295914455.24778.115.camel@haakon2.linux-iscsi.org>
	 <1295915790.15425.44.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1295915790.15425.44.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-01-24 at 18:36 -0600, James Bottomley wrote:
> On Mon, 2011-01-24 at 16:14 -0800, Nicholas A. Bellinger wrote:
> > Hi James and Co,
> > 
> > Here are the latest v4.0.0-rc7 updates for mainline drivers/target/ code
> > rebased against linux-2.6.git -> .38-rc2.  These individual patches have
> > been reviewed on linux-scsi and commited into the upstream LIO kernel
> > tree, so please consider pulling for .38-rc3:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-38-rc3
> > 
> > Also at this point, having Linus pull directly from
> > scsi-post-merge-2.6.git/for-38-rcX for mainline target bugfixes +
> > improvements may make more sense.
> > 
> > Linus/Andrew/James, please let me know which you prefer here.
> 
> Right at the moment, I'm trying to encourage a few people with
> established areas to experiment with their own git trees in SCSI, but
> the target subsystem, being a newcomer, wouldn't be one of these, so,
> for the time being, patch series over linux-scsi please for review and
> feedback.
> 

Sure, thanks for the clarification.  The same set of patches are
available against your .37-FINAL based scsi-post-merge-2.6.git/master
HEAD here:

   git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-jejb

Please let me know if you have any further questions,

--nab
