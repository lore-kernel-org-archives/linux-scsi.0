From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 2/6] SCSI HCIL: remove unused scsi_scan_single_target()
Date: Sat, 22 Oct 2005 19:53:04 -0600
Message-ID: <20051023015304.GC1605@parisc-linux.org>
References: <20051023013618.GA18201@havoc.gtf.org> <20051023013810.GB18279@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49626 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751382AbVJWBxF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 21:53:05 -0400
Content-Disposition: inline
In-Reply-To: <20051023013810.GB18279@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Sat, Oct 22, 2005 at 09:38:10PM -0400, Jeff Garzik wrote:
> -/**
> - * scsi_scan_single_target - scan the given SCSI target
> - * @shost:         adapter to scan
> - * @chan:          channel to scan
> - * @id:            target id to scan
> - **/
> -void scsi_scan_single_target(struct Scsi_Host *shost, 
> -	unsigned int chan, unsigned int id)
> -{
> -	scsi_scan_host_selected(shost, chan, id, SCAN_WILD_CARD, 1);
> -}
> -EXPORT_SYMBOL(scsi_scan_single_target);
> -

Adrian Bunk already tried to kill this one in February and hch NAKed it:
http://www.uwsg.iu.edu/hypermail/linux/kernel/0502.3/1115.html

Christoph, can it be killed yet?  ;-)
