From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [v4.13-rc BUG] system lockup when running big buffered write(4M)
 to IB SRP via mpath
Date: Wed, 23 Aug 2017 19:51:12 -0400
Message-ID: <20170823235112.GB23028@redhat.com>
References: <20170808141715.GB22763@ming.t460p>
 <1502237504.4017.1.camel@redhat.com>
 <1502245693.6511.3.camel@redhat.com>
 <c072e942-0265-f0ad-561d-0e50d50e3cb1@redhat.com>
 <1502298599.2356.7.camel@wdc.com>
 <20170823113526.GA8130@ming.t460p>
 <1503501161.2484.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1503501161.2484.3.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "ming.lei@redhat.com" <ming.lei@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "loberman@redhat.com" <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 23 2017 at 11:12am -0400,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Wed, 2017-08-23 at 19:35 +0800, Ming Lei wrote:
> > soft lockup still can be observed easily with patch d4acf3650c7c(
> > block: Make blk_mq_delay_kick_requeue_list() rerun the queue at a quiet time),
> > but no hard lockup.
> 
> Hello Ming,
> 
> I never claimed that commit d4acf3650c7c was a full solution to avoid these
> soft lockups. I assume these results mean that patch series "[PATCH 0/7]
> Device mapper and dm-mpath fixes" was not applied to the kernel used in your
> tests? A colleague of you has reported that that patch series is sufficient
> to avoid these soft lockups. See also
> https://www.redhat.com/archives/dm-devel/2017-August/msg00122.html.

FYI, I'll try to review/stage that patchset for 4.14 over the next few
days.

(I'm not yet back to working full-time but will try to handle my
upstream responsibilities)

Mike
