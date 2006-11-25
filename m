From: Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH] scsi/initio: section mismatches with HOTPLUG=n
Date: Sat, 25 Nov 2006 12:19:56 -0500
Message-ID: <1164475196.5257.105.camel@gullible>
References: <20061119185343.e4dde647.randy.dunlap@oracle.com>
	 <1164408696.2813.19.camel@mulgrave.il.steeleye.com>
	 <1164409859.5257.7.camel@gullible>
	 <1164467971.2804.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adelie.ubuntu.com ([82.211.81.139]:16259 "EHLO
	adelie.ubuntu.com") by vger.kernel.org with ESMTP id S966862AbWKYRUE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Nov 2006 12:20:04 -0500
In-Reply-To: <1164467971.2804.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Sat, 2006-11-25 at 09:19 -0600, James Bottomley wrote:
> On Fri, 2006-11-24 at 18:10 -0500, Ben Collins wrote:
> > The patch went in with about half a dozen others for similar changes, so
> > it was a group set.
> > 
> > Sorry about the mismatches. I've only been building with HOTPLUG=y.
> > 
> > I can do a patch if you want, just let me know.
> 
> Well, I was sort of hoping you weren't just randomly introducing
> __devinitdata but had all the necessary support patches for converting
> the driver to hotplug.  However, if that's not the case, the safest
> thing to do is remove the section annotation ... I don't think anyone
> cares enough about this driver to convert it fully and test it.

The MODULE_DEV_TABLE was added so userspace has an easier time loading a
driver for the device, without special rules. It wasn't meant to make
the driver hot-pluggable. I think the idea that a module alias is just
for hotplug is a little short-sighted.
