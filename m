From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: 2.6.9-rc2-mm2: 3ware card info not in /proc/scsi
Date: 24 Sep 2004 00:55:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096001755.1835.1.camel@mulgrave>
References: <20040923194322.78fb1c59.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:59816 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267720AbUIXE4F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 00:56:05 -0400
In-Reply-To: <20040923194322.78fb1c59.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Adam Radford <aradford@amcc.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-09-23 at 22:43, Andrew Morton wrote:
> Did this get broken?

The changelog says it was deliberate:

ChangeSet 1.2212 2004/09/10 17:48:45 aradford@amcc.com
  [PATCH] 3ware 5/6/7/8000 driver v1.26.02.000
  
  - Remove deprecated SCSI_IOCTL_SEND_COMMAND interface.
  - Remove deprecated /proc/scsi/3w-xxxx interface.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  - Convert entire driver to pci_driver format.
  - Remove all mdelays, replace w/msleep to fix possible watchdog
    timer issues.
  - Make all register accesses macros.
  - Remove all prototypes from header file, reorder functions to
    eliminate all prototypes but one.
  - Add sysfs 'queue_depth' setting attribute.
  - Add sysfs 'stats' attribute.
  - Fix spinlocks everywhere, remove tw_lock spinlock.
  - Remove all bitfields, add bitmask access macros.
  - Remove un-needed scsi_eh_abort entrypoint.  Controller does not
    support aborting invididual IO's, scsi_eh_reset sufficient.

I presume there's an updated utility from amcc somewhere that uses the
new sysfs interface.

James


