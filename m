From: "conway, heather" <conway_heather@emc.com>
Subject: RE: Request to add EMC Invista to the v2.6.x SCSI Blacklist...
Date: Thu, 11 Aug 2005 11:45:46 -0400
Message-ID: <FA2F59D0E55B4B4892EA076FF8704F5509DDC99C@SRGRAHAM.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:20191 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP
	id S1751096AbVHKPqA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 11:46:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, "conway, heather" <conway_heather@emc.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Hi James,
The information that I was provided is that the default for the Invista is
to report back as SCSI-3 compliant.
Hope this helps. 
Thanks.
Heather 

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Saturday, July 30, 2005 11:00 AM
To: conway, heather
Cc: 'linux-scsi@vger.kernel.org'
Subject: Re: Request to add EMC Invista to the v2.6.x SCSI Blacklist...

On Wed, 2005-07-27 at 10:22 -0400, conway, heather wrote:
> I'd like to request that the enclosed patch to scsi_devinfo.c be
considered
> for inclusion in the v2.6.x kernel.  This would add support for sparse
LUNs
> and large LUNs for the EMC Invista product.  

For 2.6, I assume this device reports compliance with SCSI-2; could you
check to see if it would actually supports the REPORT_LUNS command?  If
it does, the blacklist entry would be BLIST_REPORTLUN2; if not, then
I'll put in what you sent.

Thanks,

James

