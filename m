From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ibmvfc: byteswap scsi_id, wwpn, and node_name prior to logging
Date: Wed, 17 Feb 2016 18:30:51 -0500
Message-ID: <yq1d1ruud78.fsf@sermon.lab.mkp.net>
References: <1455229475-3984-1-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25758 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331AbcBQXbG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2016 18:31:06 -0500
In-Reply-To: <1455229475-3984-1-git-send-email-tyreld@linux.vnet.ibm.com>
	(Tyrel Datwyler's message of "Thu, 11 Feb 2016 16:24:35 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com

>>>>> "Tyrel" == Tyrel Datwyler <tyreld@linux.vnet.ibm.com> writes:

Tyrel> When logging async events the scsi_id, wwpn, and node_name values
Tyrel> are used directly from the CRQ struct which are of type
Tyrel> __be64. This can be confusing to someone looking through the log
Tyrel> on a LE system.  Instead byteswap these values to host endian
Tyrel> prior to logging.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
