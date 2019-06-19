From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V5 00/16] use sg helper to operate scatterlist
Date: Tue, 18 Jun 2019 20:29:02 -0400
Message-ID: <yq11rzqzacx.fsf@oracle.com>
References: <20190618013757.22401-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190618013757.22401-1-ming.lei@redhat.com> (Ming Lei's message
 of "Tue, 18 Jun 2019 09:37:41 +0800")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.ibm.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Brian King <brking@us.ibm.com>, Finn Thain <fthain@telegraphics.com.au>, "Juergen E . Fischer" <fischer@norbit.de>, Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org


Hi Ming,

> So convert drivers to use scatterlist helper.

I applied this series with a bunch of edits and clarifying comments. It
was quite the nightmare to rebase 5.3/scsi-queue to satisfy the ordering
requirements, locate the scattered fixes, tweak tags, etc. Hope I got
everything right.

It was almost at the point where I gave up and postponed everything to
5.4. We're at -rc5 -- it's not exactly a good time to rebase the entire
tree. However, I know the static mq allocations are causing headaches
for several distro vendors so I begrudgingly bit the bullet.

I would have liked to see more reviews from the official driver
maintainers but at the same time I didn't want to wait any longer giving
this some soak time in linux-next.

Thanks for your work on getting all the drivers fixed up! Just goes to
show how large the fallout can be from a relatively innocuous core
change.

Oh, and I held back the rtsx patch due to lack of reviews. But since
that driver is in staging I'm not too worried about it. Hope we can get
the fix for that reviewed and merged soon.

-- 
Martin K. Petersen	Oracle Linux Engineering
