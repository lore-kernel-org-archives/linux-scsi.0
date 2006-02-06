From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: How can I know the status of a MegaRAID Array?
Date: Mon, 6 Feb 2006 06:29:48 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26514204F@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:6370 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932073AbWBFN3x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 08:29:53 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Claudio Coppari <c.coppari@sintekno.it>, linux-scsi@vger.kernel.org

Hi,
On Monday, February 06, 2006 4:15 AM, Claudio Coppari wrote:
> I have installed 2 HDs with RAID 1 and it seems to work well.
> My question is: how can I know if one disk fails?
> Is there something link /proc/mdstat ?
> Alternatively: if one disk fail any message will be written 
> to the log files? 
By nature of RAID, you won't see any information for physical disk drives associated to the RAID1.
However, you will find the information for RAID1 from /proc.

Thank you,

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Claudio Coppari
> Sent: Monday, February 06, 2006 4:15 AM
> To: linux-scsi@vger.kernel.org
> Subject: How can I know the status of a MegaRAID Array?
> 
> Hi,
> I have a Fujitsu Siemens Primergy RX200 with Fedora Core 3 
> installed (Kernel 2.6.12-1.1381_FC3smp).
> The machine is equipped with the following SCSI devices:
> 
> Attached devices:
> Host: scsi0 Channel: 00 Id: 08 Lun: 00
>   Vendor: SDR      Model: GEM318P          Rev: 1   
>   Type:   Processor                        ANSI SCSI revision: 02
> Host: scsi0 Channel: 01 Id: 00 Lun: 00
>   Vendor: MegaRAID Model: LD0 RAID1 34700R Rev: 1F34
>   Type:   Direct-Access                    ANSI SCSI revision: 02
> 
> I have installed 2 HDs with RAID 1 and it seems to work well.
> My question is: how can I know if one disk fails?
> Is there something link /proc/mdstat ?
> Alternatively: if one disk fail any message will be written 
> to the log files?
> 
> Thank you very much for your support!
> 
> Claudio
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
