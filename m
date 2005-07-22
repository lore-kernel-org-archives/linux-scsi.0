From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Patch 0/2] Update aic79xx
Date: Fri, 22 Jul 2005 12:13:49 -0400
Message-ID: <1122048829.5128.1.camel@mulgrave>
References: <42E10572.6030105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:5573 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262053AbVGVQOD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2005 12:14:03 -0400
In-Reply-To: <42E10572.6030105@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>

On Fri, 2005-07-22 at 16:40 +0200, Hannes Reinecke wrote:
> I've finished the update of aic79xx to make use of the
> scsi_transport_spi infrastructure.
> The first patch is actually jgarzik's one, with some additions to make
> it work :-)
> The second patch is the integration proper. patch made a mess of it,
> however, so better to compare the files by hand ...
> 
> Hope it finds your blessing.
> Comments etc welcome.

This looks very good, thank you for doing it!

> target27:0:10: FAST-160 WIDE SCSI 320.0 MB/s ST IU (6.25 ns, offset 127)

There is a slight problem here:  ST IU isn't a legal SCSI setting (DT is
a requirement for IU), so there's something slightly wrong in the
parameter setting somewhere.  I'll take a look through the code and see
if I can spot it (probably post OLS).

James


