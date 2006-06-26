From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 14:59:11 +0200
Message-ID: <1151326751.3185.37.camel@laptopd505.fenrus.org>
References: <20060518172258.GL1604@parisc-linux.org>
	<20060529031915.GB23405@parisc-linux.org>
	<447AB2F5.2000700@s5r6.in-berlin.de>
	<20060529130515.GE23405@parisc-linux.org>
	<20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	<20060601132315.GD32143@parisc-linux.org>
	<1151270127.3617.26.camel@mulgrave.il.steeleye.com>
	<20060625224631.GD1608@parisc-linux.org>
	<1151310285.3185.16.camel@laptopd505.fenrus.org>
	<20060626124001.GG1608@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20060626124001.GG1608@parisc-linux.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>
List-Id: linux-scsi@vger.kernel.org


> Fortunately, USB is SCSI, so we can actually use this code to solve that
> problem too.  I wasn't thinking of USB when I wrote the code (because I
> didn't know there was a problem).  But really, it's very generic stuff;
> there's a list_head, a pointer to a Scsi_Host and a completion.
> 
> I'm not 100% sure what the problem is with USB. 

I seem to remember that the problem with USB was that you can't even
know how many things are still outstanding; devices are free to appear
on the bus at any time after bus power on, without specified timeout...
If the kernel can't know what's out there, it can't wait until it has a
complete picture either, just by virtue of not being able to know when
that is achieved ;-)

But I could be wrong entirely; USB storage is not something I delve into
daily...

Greetings,
   Arjan van de Ven


Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
