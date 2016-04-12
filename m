From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: fnic: Using rport->dd_data to check rport online instead of rport_lookup.
Date: Mon, 11 Apr 2016 21:53:28 -0400
Message-ID: <yq1a8kz1tk7.fsf@sermon.lab.mkp.net>
References: <20160401194445.GA21247@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46357 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbcDLBxg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2016 21:53:36 -0400
In-Reply-To: <20160401194445.GA21247@mwanda> (Dan Carpenter's message of "Fri,
	1 Apr 2016 22:44:45 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satishkh@cisco.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> The patch ce4b9e8980fa: "fnic: Using rport->dd_data to check rport
Dan> online instead of rport_lookup." from Mar 18, 2016, leads to the
Dan> following Smatch complaint:

Dan> drivers/scsi/fnic/fnic_scsi.c:457 fnic_queuecommand_lck() warn:
Dan> variable dereferenced before check 'rport' (see line 449)

Satish?

-- 
Martin K. Petersen	Oracle Linux Engineering
