From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: Request to add EMC Invista to the v2.6.x SCSI Blacklist...
Date: Thu, 11 Aug 2005 11:39:08 -0500
Message-ID: <1123778348.5062.27.camel@mulgrave>
References: <FA2F59D0E55B4B4892EA076FF8704F5509DDC99C@SRGRAHAM.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:38308 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750995AbVHKQjN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 12:39:13 -0400
In-Reply-To: <FA2F59D0E55B4B4892EA076FF8704F5509DDC99C@SRGRAHAM.eng.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "conway, heather" <conway_heather@emc.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

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


