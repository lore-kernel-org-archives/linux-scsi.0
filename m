From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [Patch 0/2] Update aic79xx
Date: Fri, 22 Jul 2005 11:47:05 -0400
Message-ID: <42E114F9.7020106@pobox.com>
References: <42E10572.6030105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:60584 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261220AbVGVPrO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2005 11:47:14 -0400
In-Reply-To: <42E10572.6030105@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hannes Reinecke wrote:
> Hi James,
> 
> I've finished the update of aic79xx to make use of the
> scsi_transport_spi infrastructure.
> The first patch is actually jgarzik's one, with some additions to make
> it work :-)
> The second patch is the integration proper. patch made a mess of it,
> however, so better to compare the files by hand ...

nice!

	Jeff



