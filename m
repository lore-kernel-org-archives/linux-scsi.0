From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Mon, 7 Jan 2008 07:44:04 -0800
Message-ID: <20080107154404.GA10880@suse.de>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
	<20080107020944.GA3637@darkstar.te-china.tietoenator.com>
	<20080107084528.GA8365@suse.de>
	<200801070101.15168.david-b@pacbell.net>
	<478227D5.8050402@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <478227D5.8050402@s5r6.in-berlin.de>
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
Cc: James.Bottomley@hansenpartnership.com, dbrownell@users.sourceforge.net, Dave Young <hidave.darkstar@gmail.com>, linux-scsi@vger.kernel.org, a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>, krh@redhat.com, stern@rowland.harvard.edu, rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 07, 2008 at 02:23:33PM +0100, Stefan Richter wrote:
> David Brownell wrote:
> > On Monday 07 January 2008, Greg KH wrote:
> >> Most of the non-driver core code should be converted to not use the
> >> lock in the class at all.  They should use a local lock instead.
> > 
> > Or better yet, that yet-to-be-written class_for_each_instance()
> > iterator ... :)
> 
> By far most of the usages of class.semaphore or class.mutex in drivers
> are to protect the class.devices list.  The only? right thing to do
> there is to keep using the class.{semaphore,mutex}.  The more elegant
> variation of this would be David's class_for_each_instance() iterator
> which would allow us to hide the locking details from the drivers.

If such functionality is needed, fine, I have no objection to that
change to move the locking logic into the driver core.

thanks,

greg k-h

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
