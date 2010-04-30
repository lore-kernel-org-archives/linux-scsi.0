From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] scsi/st: remove BKL from open
Date: Fri, 30 Apr 2010 22:03:34 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.1004302201200.6758@kai.makisara.local>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de> <201004151629.45029.arnd@arndb.de> <alpine.LNX.2.00.1004152244160.5127@kai.makisara.local> <201004152251.39636.arnd@arndb.de> <20100430021855.GA21078@nowhere>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:34566 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934244Ab0D3TEB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 15:04:01 -0400
In-Reply-To: <20100430021855.GA21078@nowhere>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, dgilbert@interlog.com, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>

On Fri, 30 Apr 2010, Frederic Weisbecker wrote:

> On Thu, Apr 15, 2010 at 10:51:38PM +0200, Arnd Bergmann wrote:
> > The st_open function is serialized through the st_dev_arr_lock
> > and the STp->in_use flag, so there is no race that the BKL
> > can protect against in the driver itself, and the function
> > does not access any global state outside of the driver that
> > might be protected with the BKL.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> 
> 
> 
> Kai, can we get your ack on this?
> 
I am sorry, I have forgotten to send it.

Acked-by: Kai Makisara <kai.makisara@kolumbus.fi>

Thanks,
Kai
