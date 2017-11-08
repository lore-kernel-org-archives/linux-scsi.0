From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Wed, 8 Nov 2017 08:39:35 +0800
Message-ID: <20171108003934.GB20599@ming.t460p>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com>
 <20171107021125.GB15090@ming.t460p>
 <1510071607.2656.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510071607.2656.17.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 07, 2017 at 04:20:08PM +0000, Bart Van Assche wrote:
> On Tue, 2017-11-07 at 10:11 +0800, Ming Lei wrote:
> > If you can reproduce, please provide me at least the following log
> > first:
> > 
> > 	find /sys/kernel/debug/block -name tags | xargs cat | grep busy
> > 
> > If any pending requests arn't completed, please provide the related
> > info in dbgfs about where is the request.
> 
> Every time I ran the above or a similar command its output was empty. I
> assume that's because the hang usually occurs in a phase where these debugfs
> attributes either have not yet been created or have already disappeared.

Could you dump all tags? Then you can see if this attribute is disappeared.

If that output is empty, it often means there isn't pending request not
completed. So if that is true, your hang is _not_ related with RESTART.

Thakns,
Ming
