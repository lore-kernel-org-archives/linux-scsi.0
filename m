From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] add scsi_driver.h
Date: 25 Jun 2003 23:18:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056601098.1846.47.camel@mulgrave>
References: <20030624064941.GB26582@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:37127 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265411AbTFZEEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2003 00:04:14 -0400
In-Reply-To: <20030624064941.GB26582@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-06-24 at 01:49, Christoph Hellwig wrote:
> include/scsi/scsi_driver.h contains =E6verything related to upper
> level drivers.  Unlike the other header moves there's no compatiblity
> this time as it's easy to fix up the few users.

This patch actually doesn't seem to contain scsi/scsi_driver.h

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
