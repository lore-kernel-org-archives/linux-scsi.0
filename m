From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Mon, 7 Jan 2008 12:25:38 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801071224200.2748-100000@iolanthe.rowland.org>
References: <47825DC1.3090102@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <47825DC1.3090102@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: a.zummo@towertech.it, dbrownell@users.sourceforge.net, Dave Young <hidave.darkstar@gmail.com>, linux-scsi@vger.kernel.org, peterz@infradead.org, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com, cbou@mail.ru, David Brownell <david-b@pacbell.net>, jarkao2@gmail.com, rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, krh@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Mon, 7 Jan 2008, Stefan Richter wrote:

> Semi off-topic:  What about struct device.sem?  Is there any chance to
> rip this out of the driver core and let drivers serialize everything?  I
> suppose not...

There isn't.  The core uses that lock.

Alan Stern


-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
