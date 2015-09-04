From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 9/10] megaraid_sas : Code refactor for use of requestorId
Date: Thu, 03 Sep 2015 23:35:12 -0400
Message-ID: <yq1lhcm97rj.fsf@sermon.lab.mkp.net>
References: <201508311159.t7VBxe85031450@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21929 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbbIDDft (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2015 23:35:49 -0400
In-Reply-To: <201508311159.t7VBxe85031450@palmhbs0.lsi.com> (sumit saxena's
	message of "Mon, 31 Aug 2015 17:24:11 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sumit.saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, kiran-kumar.kasturi@avagotech.com, uday.lingala@avagotech.com

>>>>> "Sumit" == sumit saxena <sumit.saxena@avagotech.com> writes:

Sumit> Some of the code changes was proposed by David Binderman Removed
Sumit> redudant check of requestorId. Redundant condition:
Sumit> instance.requestorId.  Check for plasma firmware 1.11 or new
Sumit> restructured to support only for specific device id

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
