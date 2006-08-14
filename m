From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Stoneridge Optac Download Tool
Date: Mon, 14 Aug 2006 10:38:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0608141035550.6352-100000@iolanthe.rowland.org>
References: <200608140710.59997.muth@hagos.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <200608140710.59997.muth@hagos.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Klaus Muth <muth@hagos.de>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 14 Aug 2006, Klaus Muth wrote:

> Yep, I noticed the missing spaces, that is the reason why I added those 
> markers (>...<) in the kprint message. But I didn't know, that this is a 
> violation of the SCSI standard.

It is.  However, the device claims to support ANSI SCSI revision 0, which 
isn't a real standard at all.  It's more like saying: "I will support 
whatever most of the pre-1990 SCSI devices supported, approximately."

> Yes, it did mount and I was able to read the data on it and it was possible to 
> create and delete files on the device. (see above, I said "this thin 
> magically works", forgetting the 'g' at "thing"). Adding the OPTAC Tool to 
> the static table may be the best fix at the moment, since my servers depend 
> heavily on SCSI, changing something more complicated than adding something to 
> a list will render me sleepless...

That does sound like the simplest solution for now.

> I'm not really happy with this solution, since
> 1. the static table is obsolete and may vanish some day as a comment says
> 2. I have to compile and test a new kernel for my 10 production servers
> 3. the device firmware may change in near future, it seems not to be finished
>    according to the facts you found out.
> 
> Thank you very much for your help. I'm working now for over 10 years with 
> linux and I'm constantly astonished, how nice and helpful all those community 
> members are, when problems arise :).

You're welcome.

Alan Stern


-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
