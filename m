From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] Adding PCI ID tables to aic7xxx and aic79xxx
Date: Tue, 12 Oct 2004 15:52:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416C3611.7030601@adaptec.com>
References: <416C15E5.7030805@adaptec.com> <416C222C.2060800@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15029 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267662AbUJLTxA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 15:53:00 -0400
In-Reply-To: <416C222C.2060800@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

Jeff Garzik wrote:
> Luben Tuikov wrote:
> 
>> Adding proper PCI ID tables to aic7xxx and aic79xx.
> 
> 
> 
> ACK, but I wonder if (long term) a follow-up patch to split up the IDs 
> into their individual components wouldn't be nice?  That would make the 
> driver much more consistent with other Linux PCI drivers.

Possibly in the future.  I just wanted to provide working
aic drivers for 2.6.9-rc3 over Andi's patch, so ppl can
boot their machines.

The patch applies over HOL scsi-misc-2.6.

	Luben


