From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: Increase REPORT_LUNS timeout
Date: Mon, 02 Nov 2015 23:03:38 -0500
Message-ID: <yq1h9l34tlx.fsf@sermon.lab.mkp.net>
References: <55D65082.6020504@linux.vnet.ibm.com> <55DDB8F3.3020308@suse.de>
	<55E70852.9050506@linux.vnet.ibm.com>
	<1441381013.2204.4.camel@HansenPartnership.com>
	<55E9BD01.3020002@linux.vnet.ibm.com>
	<1441383310.2204.12.camel@HansenPartnership.com>
	<55E9F53A.9090108@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34540 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbbKCEDx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 23:03:53 -0500
In-Reply-To: <55E9F53A.9090108@linux.vnet.ibm.com> (Brian King's message of
	"Fri, 4 Sep 2015 14:47:06 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> This patch increases the timeout used on the REPORT_LUNS to 30
Brian> seconds.  This patch solves the issue of 512 non existent LUNs
Brian> showing up after this event.

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
