From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [uml-user] [PATCH 00/12] move compat_ioctl handling into drivers
Date: Mon, 16 Nov 2009 02:02:36 +0100
Message-ID: <200911160202.36577.arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
	<20091116115715.600e346f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <user-mode-linux-user-bounces@lists.sourceforge.net>
In-Reply-To: <20091116115715.600e346f@notabene.brown>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/user-mode-linux-user>,
	<mailto:user-mode-linux-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=user-mode-linux-user>
List-Post: <mailto:user-mode-linux-user@lists.sourceforge.net>
List-Help: <mailto:user-mode-linux-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/user-mode-linux-user>,
	<mailto:user-mode-linux-user-request@lists.sourceforge.net?subject=subscribe>
Errors-To: user-mode-linux-user-bounces@lists.sourceforge.net
To: Neil Brown <neilb@suse.de>
Cc: linux-usb@vger.kernel.org, user-mode-linux-user@lists.sourceforge.net, "H. Peter Anvin" <hpa@zytor.com>, Paul Clements <Paul.Clements@steeleye.com>, Wolfram Sang <w.sang@pengutronix.de>, Andre Noll <maan@systemlinux.org>, Pavel Machek <pavel@suse.cz>, linux-i2c@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Jan Blunck <jblunck@suse.de>, Ian Kent <raven@themaw.net>, Nick Piggin <npiggin@suse.de>, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Alon Bar-Lev <alon.barlev@gmail.com>, Alan Stern <stern@rowland.harvard.edu>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Doug Gilbert <dgilbert@interlog.com>, David Vrabel <david.vrabel@csr.com>, Alexey Dobriyan <adobriyan@gmail.com>, user-mode-linux-devel@lists.sourceforge.net, Jeff Dike <jdike@addtoit.com>, Oliver Neukum <oliver@neukum.org>, linux-raid@vger.kernel.org, Tejun Heo <tj@kernel.org>Ja
List-Id: linux-scsi@vger.kernel.org

On Monday 16 November 2009, Neil Brown wrote:
> I would take the md ones into my tree, but I suspect that if
> everyone did that we would end up with lots of conflicts in
> fs/compat_ioctl.c.
> 
> So how about I just take the changes to md.c, and give you an:
> 
>    Acked-by: NeilBrown <neilb@suse.de>
> 
> for the changes to fs/compat_ioctl.c
> ??

Yes, that is exactly what I was trying to suggest. Thanks,

	Arnd <><

------------------------------------------------------------------------------
Let Crystal Reports handle the reporting - Free Crystal Reports 2008 30-Day 
trial. Simplify your report design, integration and deployment - and focus on 
what you do best, core application coding. Discover what's new with
Crystal Reports now.  http://p.sf.net/sfu/bobj-july
