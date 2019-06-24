From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V5 00/16] use sg helper to operate scatterlist
Date: Mon, 24 Jun 2019 08:54:39 -0400
Message-ID: <yq1pnn3nnxs.fsf@oracle.com>
References: <20190618013757.22401-1-ming.lei@redhat.com>
 <yq11rzqzacx.fsf@oracle.com>
 <3df71d64-78fb-c6fc-f456-a0b626abff3b@acm.org>
 <yq1wohhs62v.fsf@oracle.com>
 <CACVXFVM2ZiSwqy9QpE2A2VDWY5-dny-H=Lw2J0bEh7zuA5aj5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <CACVXFVM2ZiSwqy9QpE2A2VDWY5-dny-H=Lw2J0bEh7zuA5aj5Q@mail.gmail.com>
 (Ming Lei's message of "Mon, 24 Jun 2019 20:40:15 +0800")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.ibm.com>, Bart Van Assche <bvanassche@acm.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb <linux-usb@vger.kernel.org>, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Ming Lei <ming.lei@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Brian King <brking@us.ibm.com>, Finn Thain <fthain@telegraphics.com.au>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Juergen E . Fischer" <fischer@norbit.de>, Jim Gill <jgill@vmware.com>, Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org


Ming,

> Today I found the whole patchset disappears from 5.3/scsi-queue, seems
> something is wrong?

Your changes are in 5.3/scsi-sg. I put them in a separate branch to
avoid having to rebase the rest of the queue in case we find more
issues.

My for-next branch is based on 5.3/scsi-queue and 5.3/scsi-sg.

-- 
Martin K. Petersen	Oracle Linux Engineering
