From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Wed, 28 Jun 2006 12:03:29 -0400
Message-ID: <1151510609.3377.26.camel@mulgrave.il.steeleye.com>
References: <20060511143352.GI12272@parisc-linux.org>
	<20060518172258.GL1604@parisc-linux.org>
	<20060529031915.GB23405@parisc-linux.org>
	<447AB2F5.2000700@s5r6.in-berlin.de>
	<20060529130515.GE23405@parisc-linux.org>
	<20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	<20060601132315.GD32143@parisc-linux.org>
	<1151270127.3617.26.camel@mulgrave.il.steeleye.com>
	<20060626205832.GC10505@austin.ibm.com>
	<1151356477.2673.41.camel@mulgrave.il.steeleye.com>
	<44A2353B.1080105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <44A2353B.1080105@suse.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Hannes Reinecke <hare@suse.de>
Cc: linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Linas Vepstas <linas@austin.ibm.com>, Patrick Mansfield <patmans@us.ibm.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2006-06-28 at 09:52 +0200, Hannes Reinecke wrote:
> The only point left addressing is that you never know how long you 
> should be waiting. It would be nice if the transport class / SCSI ML 
> could give some hint somewhere to the effect 'scanning in progress'.
> Otherwise you'll end up using arbitrary timeouts and you'll always
> find 
> machines where this timeout doesn't work :-(

Well ... about 20s for a parallel bus is usual.  All the other modern
busses (FC, SAS etc.) are unscanned, so there's nothing to wait for at
the mid-layer.  Each does, however, have an internal discovery type
process which it might be possible to expose via a new API.

James



Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
