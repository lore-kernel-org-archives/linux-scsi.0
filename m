From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: Transport identifier
Date: Sat, 28 Feb 2009 10:42:07 -0500
Message-ID: <yq163iuefg0.fsf@sermon.lab.mkp.net>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
	<1235663301.19035.44.camel@localhost.localdomain>
	<yq1prh5ey7b.fsf@sermon.lab.mkp.net>
	<49A94FEB.6050400@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:30554 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbZB1Pm2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2009 10:42:28 -0500
In-Reply-To: <49A94FEB.6050400@s5r6.in-berlin.de> (Stefan Richter's message of "Sat\, 28 Feb 2009 15\:53\:31 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

Stefan> particular target breaks by READ CAPACITY 16?  I have doubts.
Stefan> Command set support is independent of transport protocol
Stefan> support.

I think that's a separate discussion we need to have.  My original patch
facilitates a check like that but it's not the only use for the
transport_id.

-- 
Martin K. Petersen	Oracle Linux Engineering
