From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Some quick scsi documentation questions:
Date: Mon, 06 Aug 2007 20:30:15 +0200
Message-ID: <46B768B7.7000803@s5r6.in-berlin.de>
References: <200707252328.28981.rob@landley.net> <46B3C36F.8060405@s5r6.in-berlin.de> <46B5FFD9.403@torque.net> <200708061129.31012.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35809 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbXHFSbR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Aug 2007 14:31:17 -0400
In-Reply-To: <200708061129.31012.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Rob Landley wrote:
> On Sunday 05 August 2007 11:50:33 am Douglas Gilbert wrote:
>> Stefan Richter wrote:
>>> Rob Landley wrote:
>>>> There are such things as external SATA enclosures, but
>>>> they're A) few and far between,
>>> What?  They are all the rage now.  :-)
...
> My point is that there are something like ten million of laptops produced 
> annually and with enclosures you're talking about a technology where the 
> entire production run generally doesn't hit six figures in unit volume.  That 
> would be "few and far between" in my book.  (Don't get me started on cell 
> phones. :)

The case of a laptop with a single sealed "spindle" (and maybe an
optical drive) is easy.  Among else, you have the following options:
  - Let the distributor figure it out for you.
  - Link the driver for the onboard SATA controller statically into
    the kernel.  Make all other SCSI low-level providers (e.g. usb-
    storage) modular.

In other words, if SATA and USB and other disks are mixed up, let the
distributor deal with the mix-up.  You only ever deal with device
aliases in /dev/disk/by-*/ or with an even higher-level representation
by the desktop environment.  _Or_ you enforce that the built-in SATA
drive is always /dev/sda, by having this drive always added first.

...
> Right now "this is a SATA drive" isn't exposed in sysfs, that I can find.

Have a look at the udev scripts or at Doug's lsscsi.  Or simply use
lsscsi like a blackbox.
-- 
Stefan Richter
-=====-=-=== =--- --==-
http://arcgraph.de/sr/
