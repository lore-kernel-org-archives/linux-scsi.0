From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] add extra inquiry byte 56 data to struct scsi_device
Date: 21 Aug 2004 09:51:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093096274.2080.30.camel@mulgrave>
References: <1093053368.3318.569.camel@mulgrave>
	<41274814.4090903@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:54912 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265805AbUHUNvi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 09:51:38 -0400
In-Reply-To: <41274814.4090903@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-08-21 at 09:03, Douglas Gilbert wrote:
> What you are proposing is only relevant for the SPI
> transport. Maybe the accessors should be placed in
> scsi_tranport_spi.c and struct scsi_device get a
> a transport dependent "hang on". Then some of that older
> SPI stuff could get migrated out of struct scsi_device
> so it stops growing.

Perhaps as a long term goal.  However, getting inquiry snooping out of
the drivers is currently more important than converting all the SPI
drivers over to using the transport class.

James


