From: Meelis Roos <mroos@linux.ee>
Subject: Re: Fw: garbled usb storage scsi vendor & model
 in 2.6.19-rc1
Date: Mon, 23 Oct 2006 07:57:01 +0300 (EEST)
Message-ID: <Pine.SOC.4.61.0610230724360.15328@math.ut.ee>
References: <Pine.LNX.4.44L0.0610191100460.6471-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0610191100460.6471-100000@iolanthe.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@osdl.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>> scsi 2:0:0:0: Direct-Access     ugin.upd .dpkg-new  PQ: 0 ANSI: 0 CCS
>>
>> The data is garbage here (obviously I'm running debian and have done
>> daily upgrade recently). Other than that message, the device appeared
>> running fine. But it still worries.
>
> Try using the patch below.  If you still see the same garbage showing up,
> it must be because the drive is sending this garbage to your computer.

Tried the patch, still garbage. It returns different garbage each time, 
and it has returned sensible data before. Since the garbage contains 
debian-specific strings sometimes, it seems to come from system RAM 
(someone is overwriting scsi data?).

This is not x86_64 specific, the same happened on yesterdays 
2.6.19-rc2+git on i386. Have not yet compiled and older kernel to really 
see if it still works with older kernel.

-- 
Meelis Roos (mroos@linux.ee)

-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
