From: Doug Ledford <dledford@xsintricity.com>
Subject: Re: [SPAM] Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 14:55:50 -0400
Message-ID: <1151348151.4936.8.camel@fc5.xsintricity.com>
References: <20060529031915.GB23405@parisc-linux.org>
	<447AB2F5.2000700@s5r6.in-berlin.de>
	<20060529130515.GE23405@parisc-linux.org>
	<20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru>
	<20060601132315.GD32143@parisc-linux.org>
	<1151270127.3617.26.camel@mulgrave.il.steeleye.com>
	<20060625224631.GD1608@parisc-linux.org>
	<1151310285.3185.16.camel@laptopd505.fenrus.org>
	<20060626124001.GG1608@parisc-linux.org>
	<20060626144442.GA13319@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20060626144442.GA13319@one-eyed-alien.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-hotplug-devel-bounces@lists.sourceforge.net
Errors-To: linux-hotplug-devel-bounces@lists.sourceforge.net
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Patrick Mansfield <patmans@us.ibm.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, Arjan van de Ven <arjan@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2006-06-26 at 07:44 -0700, Matthew Dharm wrote:

> As for using one Scsi_Host... there are several usb-storage devices which
> attach to an entire SCSI bus (not just a single target), so can't make each
> device it's own target.

This makes no sense to me at all.  The USB devices attach to a USB bus,
the whole notion of a SCSI bus for USB devices is as nothing more than
an abstraction, and should be able to be arbitrarily changed in the USB
stack any time you wish.  In short, you aren't doing SCSI selections
over a USB bus, so why should SCSI target IDs vs. host IDs matter?
Aren't they just all mapped in the driver to the USB device anyway?

-- 
Doug Ledford <dledford@xsintricity.com>



Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
