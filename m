From: "conway, heather" <conway_heather@emc.com>
Subject: RE: Request to add EMC Invista to the v2.6.x SCSI Blacklist...
Date: Mon, 15 Aug 2005 16:33:52 -0400
Message-ID: <FA2F59D0E55B4B4892EA076FF8704F5509DDC9D0@SRGRAHAM.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:2793 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP id S932677AbVHPMVm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2005 08:21:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, "conway, heather" <conway_heather@emc.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Hi James,
I will request additional information from the engineer and will get back to
you as soon as I can.
Thanks.
Heather

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Thursday, August 11, 2005 12:39 PM
To: conway, heather
Cc: 'linux-scsi@vger.kernel.org'
Subject: RE: Request to add EMC Invista to the v2.6.x SCSI Blacklist...

On Thu, 2005-08-11 at 11:45 -0400, conway, heather wrote:
> The information that I was provided is that the default for the Invista is
> to report back as SCSI-3 compliant.
> Hope this helps. 

Well, actually, now I'm confused.  REPORT_LUNS is mandatory for a SCSI3
compliant device, and if the device reports SCSI-3 compliance we
automatically try a REPORT LUNS scan, which should mean that
BLIST_LARGE_LUN and BLIST_SPARSE_LUN are unnecessary, since we add all
LUNs returned by the scan (up to the limit of the HBA).

Could we try debugging this device to find out what its problem is?

James

