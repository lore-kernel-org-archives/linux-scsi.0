From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Prevent hang_check firing during long I/O
Date: Fri, 24 Sep 2010 15:52:39 +0200
Message-ID: <4C9CAD27.1030705@kernel.dk>
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BEB49.2060208@interlog.com>	 <4C9C129E.5050504@teksavvy.com> <4C9C2039.8050903@teksavvy.com>	 <4C9C6B7D.1060805@kernel.dk> <1285336273.9259.2.camel@corey>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1285336273.9259.2.camel@corey>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: dgilbert@interlog.com, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 2010-09-24 15:51, Mark Lord wrote:
> During long I/O operations, the hang_check timer may fire,
> trigger stack dumps that unnecessarily alarm the user.
> 
> Eg.  hdparm --security-erase NULL /dev/sdb  ## can take *hours* to complete
> 
> So, if hang_check is armed, we should wake up periodically
> to prevent it from triggering.  This patch uses a wake-up interval
> equal to half the hang_check timer period, which keeps overhead low enough.

Applied, thanks.

-- 
Jens Axboe
