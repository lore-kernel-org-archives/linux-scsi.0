From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: replace deprecated hosts.h file
Date: Sun, 30 May 2004 05:25:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B9A886.2000105@pobox.com>
References: <20040529142126.GA31365@devserv.devel.redhat.com> <40B8A7FA.8070802@pobox.com> <20040530084219.GA2136@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:29164 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261425AbUE3JZl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 May 2004 05:25:41 -0400
In-Reply-To: <20040530084219.GA2136@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Arjan van de Ven wrote:
> On Sat, May 29, 2004 at 11:10:50AM -0400, Jeff Garzik wrote:
> 
>>Rejected, libata stays with the old headers until 2.7 (when it leaves scsi).
> 
> 
> Patch without libata bits below.

Bullshit, and therefore, rejected again.


> diff -purN linux-2.6.6/drivers/scsi.org/ata_piix.c linux-2.6.6/drivers/scsi/ata_piix.c
> --- linux-2.6.6/drivers/scsi.org/ata_piix.c	2004-05-12 17:45:57.913960000 +0200
> +++ linux-2.6.6/drivers/scsi/ata_piix.c	2004-05-12 17:46:19.796634288 +0200

> diff -purN linux-2.6.6/drivers/scsi.org/libata-core.c linux-2.6.6/drivers/scsi/libata-core.c
> --- linux-2.6.6/drivers/scsi.org/libata-core.c	2004-05-12 17:45:57.936957000 +0200
> +++ linux-2.6.6/drivers/scsi/libata-core.c	2004-05-12 17:46:21.456381968 +0200

> diff -purN linux-2.6.6/drivers/scsi.org/libata-scsi.c linux-2.6.6/drivers/scsi/libata-scsi.c
> --- linux-2.6.6/drivers/scsi.org/libata-scsi.c	2004-05-12 17:45:57.937957000 +0200
> +++ linux-2.6.6/drivers/scsi/libata-scsi.c	2004-05-12 17:46:21.478378624 +0200

