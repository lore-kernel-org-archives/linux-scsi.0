From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Fri, 11 Jan 2008 10:40:57 +0800
Message-ID: <a8e1da0801101840l244047c4o136ee6d71c8f9c45@mail.gmail.com>
References: <20080107154404.GA10880@suse.de> <20080107172009.GA25943@suse.de>
	<a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com>
	<20080108224837.GA19623@suse.de>
	<a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com>
	<20080109061316.GA3249@darkstar.te-china.tietoenator.com>
	<a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com>
	<a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com>
	<20080110094843.GA3014@darkstar.te-china.tietoenator.com>
	<20080110183917.GA20188@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20080110183917.GA20188@suse.de>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Greg KH <gregkh@suse.de>
Cc: a.zummo@towertech.it, krh@redhat.com, rtc-linux@googlegroups.com, linux-scsi@vger.kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com, cbou@mail.ru, Stefan Richter <stefanr@s5r6.in-berlin.de>, stern@rowland.harvard.edu, spi-devel-general@lists.sourceforge.net, David Brownell <david-b@pacbell.net>, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Jan 11, 2008 2:39 AM, Greg KH <gregkh@suse.de> wrote:
> On Thu, Jan 10, 2008 at 05:48:43PM +0800, Dave Young wrote:
> > The patches are done on my side, please help to check.
>
> Along with all of the other comments from people, I have a few.
>
> > This is the first one of the series about driver core changes.
> > If this one is accepted and there's no other problem I will post the others for maintainer's review (they need your comment and help because I don't know well about the specific driver logic).
> >
> > Thanks a lot in advance.
> > ---
> >
> > 1. convert class semaphore to mutex.
> > 2. add class iterater functions to encapsulate the detail of class devices/children list iterating :
> >       class_for_each_device
> >       class_find_device
> >       class_for_each_child
> >       class_find_child
>
> No, please create 1 patch per type-of-change.
>
> So in this case you would have a series of patches:
>         1) add the class iterator functions
>         2-n) convert the existing places in the kernel using the
>              class->semaphore to use the new iterator functions
>         n+1) convert class semaphore to mutex, which should only touch
>              the driver core

Thanks,  you are quite right. I will do it when I update the patch next time.

>
> That way everything builds along the way, and it's easy to understand
> and review.
>
> Oh, and please start a new thread when you create a new patch like this
> so it doesn't get burried in people's inboxes...

Will do when the new patch available.

>
> thanks,
>
> greg k-h
>

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
