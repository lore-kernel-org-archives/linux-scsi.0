From: Greg KH <greg@kroah.com>
Subject: Re: Fw: [BUG] USB Storage OOPS and a D state process in 2.6.10
Date: Mon, 10 Jan 2005 09:39:47 -0800
Message-ID: <20050110173947.GA30735@kroah.com>
References: <200501102114.37744.harisri@internode.on.net> <Pine.LNX.4.44L0.0501101212160.1334-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0501101212160.1334-100000@ida.rowland.org>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Srihari Vijayaraghavan <harisri@internode.on.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 10, 2005 at 12:33:49PM -0500, Alan Stern wrote:
> It's not that simple.  Your log contained two different sorts of errors.  
> The first occurred right near the start:
> 
> Jan 10 20:24:46 desktop kernel: usb 1-3: USB disconnect, address 3
> Jan 10 20:24:46 desktop kernel: 50-fstab-sync.h[5147]: segfault at 0000000000000000 rip 000000379706f6b2 rsp 0000007fbffff388 error 4
> Jan 10 20:24:46 desktop kernel: 50-fstab-sync.h[5161]: segfault at 0000000000000000 rip 000000379706f6b2 rsp 0000007fbffff6d8 error 4
> 
> This looks like a problem in a user program, not in the kernel.  I have no 
> idea what 50-fstab-sync.h is.  Part of udev perhaps?  Greg, do you know?

I think it might be part of HAL, it's not part of udev.  Ah yes, it's at
/etc/hal/device.d/50-fstab-sync.hal on my box.

thanks,

greg k-h


-------------------------------------------------------
The SF.Net email is sponsored by: Beat the post-holiday blues
Get a FREE limited edition SourceForge.net t-shirt from ThinkGeek.
It's fun and FREE -- well, almost....http://www.thinkgeek.com/sfshirt
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
