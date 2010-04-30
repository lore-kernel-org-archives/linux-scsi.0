From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] scsi/st: remove BKL from open
Date: Fri, 30 Apr 2010 04:18:58 +0200
Message-ID: <20100430021855.GA21078@nowhere>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de> <201004151629.45029.arnd@arndb.de> <alpine.LNX.2.00.1004152244160.5127@kai.makisara.local> <201004152251.39636.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:60956 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab0D3SuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 14:50:15 -0400
Received: by wwb34 with SMTP id 34so414717wwb.19
        for <linux-scsi@vger.kernel.org>; Fri, 30 Apr 2010 11:50:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <201004152251.39636.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: dgilbert@interlog.com, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>

On Thu, Apr 15, 2010 at 10:51:38PM +0200, Arnd Bergmann wrote:
> The st_open function is serialized through the st_dev_arr_lock
> and the STp->in_use flag, so there is no race that the BKL
> can protect against in the driver itself, and the function
> does not access any global state outside of the driver that
> might be protected with the BKL.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---



Kai, can we get your ack on this?

Thanks.

