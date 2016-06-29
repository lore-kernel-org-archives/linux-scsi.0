From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH} SCSI: fix new bug in scsi_dev_info_list string matching
Date: Wed, 29 Jun 2016 00:54:45 -0400
Message-ID: <yq1wpl8siga.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.1606231454380.1334-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:25882 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbcF2E4Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2016 00:56:16 -0400
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u5T4t5oU032685
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2016 04:56:15 GMT
In-Reply-To: <Pine.LNX.4.44L0.1606231454380.1334-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 23 Jun 2016 15:05:26 -0400 (EDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> Commit b704f70ce200 ("SCSI: fix bug in scsi_dev_info_list
Alan> matching") changed the way vendor- and model-string matching was
Alan> carried out in the routine that looks up entries in a SCSI devinfo
Alan> list.  The new matching code failed to take into account the case
Alan> of a maximum-length string; in such cases it could end up testing
Alan> for a terminating '\0' byte beyond the end of the memory allocated
Alan> to the string.  This out-of-bounds bug was detected by UBSAN.

Applied to 4.7/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
