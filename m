From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 1/2] scsi-mq: Only show the CDB if available
Date: Tue, 5 Dec 2017 13:00:09 +0800
Message-ID: <20171205050008.GA9989@ming.t460p>
References: <20171205003809.1705-1-bart.vanassche@wdc.com>
 <20171205003809.1705-2-bart.vanassche@wdc.com>
 <20171205011536.GC8365@ming.t460p>
 <1512439190.2739.0.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1512439190.2739.0.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 05, 2017 at 01:59:51AM +0000, Bart Van Assche wrote:
> On Tue, 2017-12-05 at 09:15 +0800, Ming Lei wrote:
> > On Mon, Dec 04, 2017 at 04:38:08PM -0800, Bart Van Assche wrote:
> > > Since the next patch will make it possible that scsi_show_rq() gets
> > > called before the CDB pointer is changed into a non-NULL value,
> > > only show the CDB if the CDB pointer is not NULL. Additionally,
> > > show the request timeout and SCSI command flags. This patch also
> > > fixes a bug that was reported by Ming Lei. See also Ming Lei,
> > > scsi_debugfs: fix crash in scsi_show_rq(), linux-scsi, 7 November
> > > 2017 (https://marc.info/?l=linux-block&m=151006655317188).
> > 
> > Please cook a patch for fixing the crash issue only, since we need
> > to backport the fix to stable kernel.
> 
> The code that is touched by this patch is only used for kernel debugging.
> I will do this if others agree with your opinion.

No, do not mix two different things in one patch, especially the fix part
need to be backported to stable.

The fix part should aim at V4.15, and the other part can be a V4.16
stuff.

-- 
Ming
