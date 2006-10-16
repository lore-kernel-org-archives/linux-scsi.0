From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] libsas: support NCQ for SATA disks
Date: Mon, 16 Oct 2006 18:34:08 -0500
Message-ID: <1161041648.3433.40.camel@mulgrave.il.steeleye.com>
References: <453027A9.3060606@us.ibm.com>
	 <1160934124.3544.7.camel@mulgrave.il.steeleye.com>
	 <45328141.5020705@us.ibm.com>
	 <0E9A17FC-4047-48AE-A283-520B87E7F28D@mac.com>
	 <19106af40610151849n41a11e4frd8088797a4e1e65@mail.gmail.com>
	 <1161023130.3433.21.camel@mulgrave.il.steeleye.com>
	 <4533FAE4.3010601@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:42458 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750805AbWJPXoG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 19:44:06 -0400
In-Reply-To: <4533FAE4.3010601@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andy Warner <andyw@pobox.com>, Mark Rustad <mrustad@mac.com>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>

On Mon, 2006-10-16 at 17:34 -0400, Jeff Garzik wrote:
> As an aside, please clean up that magic number by assigning it a named 
> constant (suggest SATA_FIS_H2D_REG) in include/linux/ata.h.

Fine by me ... I thought there would be one, but libata-core also uses
the hex value.  Why don't you put it in and I'll convert aic94xx
over ... that way we don't get into any cross tree dependencies?

James


