From: Greg KH <greg@kroah.com>
Subject: Re: Usb in 2.6 breaks proc
Date: Thu, 7 Aug 2003 16:49:32 -0700
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20030807234932.GA13780@kroah.com>
References: <20030807191740.C27716@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20030807191740.C27716@devserv.devel.redhat.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-usb-devel@lists.sourceforge.net, warren@togami.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 07, 2003 at 07:17:40PM -0400, Pete Zaitcev wrote:
> Greg, Matt & folks:
> 
> There was a tangential report from one of our users that /proc
> seems to get corrupt when usb-storage is rmmod-ed and inserted again.
> 
> Kernel 2.6.0-0.test2.1.29 (Arjan's -test2 based RPM).
> 
> Problem looks like this:
> 
> [root@laptop scsi]# pwd
> /proc/scsi
> [root@laptop scsi]# find
> .
> ./usb-storage
> ./usb-storage/2
> ./usb-storage
> ./usb-storage/2
> ./device_info
> ./scsi

Ouch, could this be a scsi issue?  I know a bunch of patches are pending
to get into Linus's tree with regards to scsi reference counting and
such.

thanks,

greg k-h


-------------------------------------------------------
This SF.Net email sponsored by: Free pre-built ASP.NET sites including
Data Reports, E-commerce, Portals, and Forums are available now.
Download today and enter to win an XBOX or Visual Studio .NET.
http://aspnet.click-url.com/go/psa00100003ave/direct;at.aspnet_072303_01/01
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
