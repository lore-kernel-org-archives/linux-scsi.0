From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Thu, 10 Jan 2008 10:41:15 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801101038580.4267-100000@iolanthe.rowland.org>
References: <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41166 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755186AbYAJPlQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 10:41:16 -0500
In-Reply-To: <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>, James.Bottomley@hansenpartnership.com, SCSI development list <linux-scsi@vger.kernel.org>, a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru, Kernel development list <linux-kernel@vger.kernel.org>, David Brownell <david-b@pacbell.net>, krh@redhat.com, rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com

On Thu, 10 Jan 2008, Dave Young wrote:

> Hi,
> The patches are done on my side, please help to check. 
> 
> This is the first one of the series about driver core changes. 
> If this one is accepted and there's no other problem I will post the others for maintainer's review (they need your comment and help because I don't know well about the specific driver logic).

Before spending too much time on all these conversions, shouldn't you 
first determine whether they will work with the lockdep checker?  In 
one of your earlier messages there was a clear indication that they 
will not.

Alan Stern

