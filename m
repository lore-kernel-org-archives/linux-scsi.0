From: Meelis Roos <mroos@linux.ee>
Subject: Re: Fw: garbled usb storage scsi vendor & model
 in 2.6.19-rc1
Date: Tue, 24 Oct 2006 23:47:06 +0300 (EEST)
Message-ID: <Pine.SOC.4.61.0610242346300.17472@math.ut.ee>
References: <Pine.LNX.4.44L0.0610241557500.6203-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0610241557500.6203-100000@iolanthe.rowland.org>
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

> The patch is below.  This replaces the patch I sent earlier.

Thank you, it works just fine!

scsi scan: INQUIRY result too short (5), using 36
scsi 1:0:0:0: Direct-Access     GENERIC  USB DISK DEVICE  1.00 PQ: 0 ANSI: 0 CCS

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
