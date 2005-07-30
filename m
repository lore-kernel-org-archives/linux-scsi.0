From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Request to add EMC Invista to the v2.6.x SCSI Blacklist...
Date: Sat, 30 Jul 2005 10:00:24 -0500
Message-ID: <1122735625.5055.3.camel@mulgrave>
References: <FA2F59D0E55B4B4892EA076FF8704F5509DDC7A5@srgraham.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:20958 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262980AbVG3PA2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jul 2005 11:00:28 -0400
In-Reply-To: <FA2F59D0E55B4B4892EA076FF8704F5509DDC7A5@srgraham.eng.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "conway, heather" <conway_heather@emc.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Wed, 2005-07-27 at 10:22 -0400, conway, heather wrote:
> I'd like to request that the enclosed patch to scsi_devinfo.c be considered
> for inclusion in the v2.6.x kernel.  This would add support for sparse LUNs
> and large LUNs for the EMC Invista product.  

For 2.6, I assume this device reports compliance with SCSI-2; could you
check to see if it would actually supports the REPORT_LUNS command?  If
it does, the blacklist entry would be BLIST_REPORTLUN2; if not, then
I'll put in what you sent.

Thanks,

James


