From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix up request buffer reference in various scsi drivers
Date: Thu, 08 Jun 2006 09:06:18 -0400
Message-ID: <1149771978.3436.4.camel@mulgrave.il.steeleye.com>
References: <20060603112113.GA17018@lst.de>  <44880BEA.90707@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:32418 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964833AbWFHNGi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jun 2006 09:06:38 -0400
In-Reply-To: <44880BEA.90707@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@lst.de>, jejb@SteelEye.com, linux-scsi@vger.kernel.org

On Thu, 2006-06-08 at 07:37 -0400, Jeff Garzik wrote:
> False statement, for libata.

Could you amplify this statement, please ... I looked through the head
of libata-dev and it seems that these are still the only two bufflen
uses, which still do look obviously wrong ... I don't see where the
problem in libata with this is?

> Please CC the author (me) or linux-ide, at least, when you touch
> libata.

The tradition is that for infrastructure changes like this, particularly
ones that are trivial, as this appears to be, you simply copy the scsi
list and don't have to sweep up the individual maintainers of each
driver.

James


