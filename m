From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: RFC: Transport identifier
Date: Fri, 27 Feb 2009 21:50:14 -0700
Message-ID: <20090228045014.GP16891@parisc-linux.org>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net> <1235663301.19035.44.camel@localhost.localdomain> <yq1prh5ey7b.fsf@sermon.lab.mkp.net> <20090227163326V.fujita.tomonori@lab.ntt.co.jp> <yq1eixjdws0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58431 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZB1Euc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Feb 2009 23:50:32 -0500
Content-Disposition: inline
In-Reply-To: <yq1eixjdws0.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, Feb 27, 2009 at 11:13:03PM -0500, Martin K. Petersen wrote:
> The following patch below sits somewhere between my original take and
> your patch.  Those transports that have classes implemented fill out the
> id like you did.  The ones that don't (ATA, FireWire and USB) set it
> manually.  Best of both worlds, IMHO.

You seem to have missed the patch to scsi_transport_spi.c.
There's also a lot of parallel SCSI drivers that don't use
scsi_transport_spi.c yet.  I'm OK with them being 'unknown' and
eventually people patching them (or perhaps better, converting them to
use scsi_transport_spi!), but thought it was worth mentioning.

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
> diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
