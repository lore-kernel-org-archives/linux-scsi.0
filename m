From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI device/adapter/bus address correlation?
Date: 02 Sep 2004 19:36:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094168177.2097.154.camel@mulgrave>
References: <200409021719.15267.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:7346 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269163AbUIBXg1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Sep 2004 19:36:27 -0400
In-Reply-To: <200409021719.15267.bjorn.helgaas@hp.com>
List-Id: linux-scsi@vger.kernel.org
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-09-02 at 19:19, Bjorn Helgaas wrote:
> Not being a real SCSI person, I'm sure there's some clever way I'm
> supposed to figure out which disk is /dev/sda.  But sometimes it's
> not clear from the kernel boot messages, particularly for drivers
> that don't print the PCI address of the adapter.

You do it like this:

jejb@gsyprf11> ls -l /sys/block/sda/device
lrwxrwxrwx  1 root root 0 Aug 22 10:57 /sys/block/sda/device ->
../../devices/parisc0/parisc0:0/pci0000:00/0000:00:01.1/host1/1:0:15:0/

There you see the full attachment tree of the pci device.

> Is there any interest in a patch like the attached, which makes
> things look like this:

Not really, unless it's part of a conversion to dev_printk().

James


