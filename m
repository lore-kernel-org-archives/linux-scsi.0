From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 16:41:37 -0500
Message-ID: <1151358097.2673.43.camel@mulgrave.il.steeleye.com>
References: <20060518172258.GL1604@parisc-linux.org>
	<20060529031915.GB23405@parisc-linux.org>
	<447AB2F5.2000700@s5r6.in-berlin.de>
	<20060529130515.GE23405@parisc-linux.org>
	<20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	<20060601132315.GD32143@parisc-linux.org>
	<1151270127.3617.26.camel@mulgrave.il.steeleye.com>
	<20060626205832.GC10505@austin.ibm.com>
	<1151356477.2673.41.camel@mulgrave.il.steeleye.com>
	<20060626212155.GD10505@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20060626212155.GD10505@austin.ibm.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Patrick Mansfield <patmans@us.ibm.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2006-06-26 at 16:21 -0500, Linas Vepstas wrote:
> Its possible that I'm making a confused commont based on my
> mis-understanding a conversation I'm not following closely, but ... 
> 
> Didn't the last patch result in the boot process hanging until
> all scsi devices were discovered? I was concerned that this might 
> take too long. But if there's no hang, then no problem.

The last patch was a module distros could use to wait for all bus scans
to complete.

If you simply want the behaviour where you launch aync scans and wait
for root to show up before proceeding, then you code that in udev.

James



Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
