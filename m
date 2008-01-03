From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Thu, 3 Jan 2008 15:21:36 +0800
Message-ID: <a8e1da0801022321u236d5f23ub6b5b8b61ebea505@mail.gmail.com>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
	 <20080103070609.GA1677@ff.dom.local>
	 <20080103072404.GB1677@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.242]:40475 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751911AbYACHVh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 02:21:37 -0500
Received: by hs-out-2122.google.com with SMTP id 54so3901631hsz.5
        for <linux-scsi@vger.kernel.org>; Wed, 02 Jan 2008 23:21:36 -0800 (PST)
In-Reply-To: <20080103072404.GB1677@ff.dom.local>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: gregkh@suse.de, stern@rowland.harvard.edu, peterz@infradead.org, david-b@pacbell.net, davem@davemloft.net, krh@redhat.com, stefanr@s5r6.in-berlin.de, dbrownell@users.sourceforge.net, James.Bottomley@hansenpartnership.com, a.zummo@towertech.it, cbou@mail.ru, dwmw2@infradead.org, khali@linux-fr.org, i2c@lm-sensors.org, linux1394-devel@lists.sourceforge.net, spi-devel-general@lists.sourceforge.net, linux-scsi@vger.kernel.org, rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org

On Jan 3, 2008 3:24 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> On Thu, Jan 03, 2008 at 08:06:09AM +0100, Jarek Poplawski wrote:
> > On Thu, Jan 03, 2008 at 01:50:20PM +0800, Dave Young wrote:
> > > Convert semaphore to mutex in struct class.
> > ...
> > > One lockdep warning detected as following, thus use mutex_lock_nested with SINGLE_DEPTH_NESTING in class_device_add
> > >
> > > Jan  3 10:45:15 darkstar kernel: =============================================
> > > Jan  3 10:45:15 darkstar kernel: [ INFO: possible recursive locking detected ]
> > > Jan  3 10:45:15 darkstar kernel: 2.6.24-rc6-mm1-mutex #1
> > > Jan  3 10:45:15 darkstar kernel: ---------------------------------------------
> > ...
> > > If there's anything missed please help to point out, thanks.
> >
> > Dave, IMHO it's not 'the right' way to do it: [...]
>
> OOPS! (I was sleeping...) Unless it has turned out it's not so hard
> here, and you are quite sure there should be no more warnings after
> this one nesting annotation - then of course, this is the right way!

Thanks ;)
I don't know if there's other possible warning places with this mutex
or not,  if you have any ideas about this, please tell me.

>
> Sorry (?)
> Jarek P.
>
