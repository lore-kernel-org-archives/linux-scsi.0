From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 14/14] iscsi-target: Add Makefile/Kconfig and update
	TCM top level
Date: Thu, 12 May 2011 13:04:10 -0700
Message-ID: <1305230650.19744.188.camel@haakon2.linux-iscsi.org>
References: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
	 <1305184041-32189-15-git-send-email-nab@linux-iscsi.org>
	 <20110512081357.106419c0.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110512081357.106419c0.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-05-12 at 08:13 -0700, Randy Dunlap wrote:
> On Thu, 12 May 2011 00:07:21 -0700 Nicholas A. Bellinger wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Add Makefile/Kconfig and update drivers/target/[Makefile,Kconfig]
> > to include the fabric module.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/Kconfig        |    1 +
> >  drivers/target/Makefile       |    1 +
> >  drivers/target/iscsi/Kconfig  |   18 ++++++++++++++++++
> >  drivers/target/iscsi/Makefile |   20 ++++++++++++++++++++
> >  4 files changed, 40 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/target/iscsi/Kconfig
> >  create mode 100644 drivers/target/iscsi/Makefile
> > 
> > diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
> > new file mode 100644
> > index 0000000..abdb8f9
> > --- /dev/null
> > +++ b/drivers/target/iscsi/Kconfig
> > @@ -0,0 +1,18 @@
> > +config ISCSI_TARGET
> > +	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
> > +	depends on m
> > +	select CRYPTO
> > +	select CRYPTO_CRC32C
> > +	select CRYPTO_CRC32C_INTEL if X86
> > +	help
> > +	Say M here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
> > +	Target Mode Stack.
> 
> Just curious:  why is this available only as a loadable module?
> 

Hi Randy,

Thanks for your review.  Btw, there is no hard-requirement for
iscsi-target to be built as a module here..  Dropping the bogus 'depends
on m' section from the above and pushing into lio-core-2.6.git now.

James, can you please include this minor change into the initial
squashed merge, or do you prefer this be included in a follow-up
respin..?

Thanks!

--nab
