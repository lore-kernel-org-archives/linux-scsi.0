From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute "alias"
 in gendisk"
Date: Wed, 9 Nov 2011 18:38:21 +0100
Message-ID: <CAPXgP13x9vvZ3pfW7u=o5rEaTAg_xV7=RC_UFuhk_aRdB4G0vg@mail.gmail.com>
References: <20111109162512.GB1260@google.com> <1320859800.8294.27.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1320859800.8294.27.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 9, 2011 at 18:30, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2011-11-09 at 08:25 -0800, Tejun Heo wrote:

> No, I can't agree with this ... if you propose a working alternative,

The solution to this problem is to let udev log the known symlinks to
the log stream at device discovery time. That way you can log _all_
kernel device messages to the currently know disk names. This works
already even on old systems,

> I'm listening, but in the absence of one, I think the hack fills a gap

There is no gap.

> we have in log analysis and tides us over until we have an agreed on
> proper solution (at which point, I'm perfectly happy to pull the hack
> back out).

Log analysis works just fine with the udev solution and provides the
far better solution to this exact problem, so please revert it.

Such hacks are not supposed to get in, and its really hard to get them
out again.

Thanks,
Kay
