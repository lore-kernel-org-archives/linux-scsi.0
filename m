From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v4 10/10] scsi: Implement blk_mq_ops.show_rq()
Date: Mon, 24 Apr 2017 16:23:59 -0700
Message-ID: <20170424232359.GA21578@vader.DHCP.thefacebook.com>
References: <20170421234026.18970-1-bart.vanassche@sandisk.com>
 <20170421234026.18970-11-bart.vanassche@sandisk.com>
 <yq1k269ij5f.fsf@oracle.com>
 <1493070575.3394.19.camel@sandisk.com>
 <yq1zif5fl61.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1zif5fl61.fsf@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "hare@suse.com" <hare@suse.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 24, 2017 at 07:19:50PM -0400, Martin K. Petersen wrote:
> 
> Bart,
> 
> > SCSI tracing has to be enabled before a test is started, produces a
> > huge amount of data, and deriving state information from a huge trace
> > is far from easy. The information in debugfs provides an easy to read
> > overview of the current state without having to analyze megabytes of
> > traces, without introducing any slowdown and without having to enable
> > any tracing mechanism from beforehand.
> 
> Fair enough. Just seems like there's an obvious overlap in plumbing.
> Don't know if that can be leveraged instead of introducing something
> completely new?

The debugfs infrastructure is already there, and it already supports
showing requests. Bart is just exposing the SCSI information.
