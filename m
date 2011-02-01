From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 17/32] scsi/ibmvstgt: use system_wq instead of vtgtd
 workqueue
Date: Tue, 1 Feb 2011 15:29:46 +0100
Message-ID: <20110201142946.GN14211@htj.dyndns.org>
References: <AANLkTi=Fg8wjf-XfVsq0X4RWx7i8F1V7gC6-8Y5LPbnL@mail.gmail.com>
 <20110124162414.GD27510@htj.dyndns.org>
 <20110201104043.GH14211@htj.dyndns.org>
 <20110201231836D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110201231836D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 01, 2011 at 11:18:54PM +0900, FUJITA Tomonori wrote:
> > Ping.  Are you interested in doing the conversion?
> 
> FYI, this driver will be replaced shortly. Now I have the working
> ibmvscsis driver for the new target framework. I'll submit it this
> week. So this driver will be removed soon or later (if James prefer to
> go through the proper Documentation/feature-removal-schedule.txt
> process, it'll be for some time). You could leave this alone, I guess.

I see.  I'll drop the patch then.  Please keep in mind that I'm
planning on marking flush_scheduled_work() deprecated in linux-next in
a month or so.  create_singlethread_workqueue() will follow in the
next cycle and then create_workqueue() the next.

Thank you.

-- 
tejun
