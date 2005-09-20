From: Greg KH <greg@kroah.com>
Subject: Re: oops on usb storage device disconnect with 2.6.14-rc1
Date: Tue, 20 Sep 2005 07:48:47 -0700
Message-ID: <20050920144847.GA11094@kroah.com>
References: <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org> <20050915192912.GA7077@kroah.com> <1126814226.4821.48.camel@mulgrave> <1126818483.4821.60.camel@mulgrave> <20050915221946.GA28441@us.ibm.com> <1126823917.4821.70.camel@mulgrave> <1127003717.4794.10.camel@mulgrave> <1127073920.4847.34.camel@mulgrave> <20050918220126.GA6317@kroah.com> <1127143172.4869.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <1127143172.4869.1.camel@mulgrave>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 19, 2005 at 10:19:32AM -0500, James Bottomley wrote:
> On Sun, 2005-09-18 at 15:01 -0700, Greg KH wrote:
> > Should I apply any additional patches too?  Or just this one will
> > suffice?
> 
> Just to make assurances doubly sure, could you remove all the scsi
> patches and just pull the scsi git tree at
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> into your build and verify that everything works (the module is
> removable and the error thread stops).

Yes, with this tree, on top of Linus's latest (2.6.14-rc2), it works
just fine!

thanks,

greg k-h


-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
