From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] ipr: Don't log unnecessary 9084 error details
Date: Mon, 19 Sep 2016 11:58:06 -0400
Message-ID: <yq1a8f3anld.fsf@sermon.lab.mkp.net>
References: <20160916215136.9E5F8124047@b01ledav002.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31344 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbcISP6X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 11:58:23 -0400
In-Reply-To: <20160916215136.9E5F8124047@b01ledav002.gho.pok.ibm.com> (Brian
        King's message of "Fri, 16 Sep 2016 16:51:36 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> A 9084 error gets logged by the ipr adapter when adapter raw mode
Brian> gets enabled. A bunch of unformatted hex data also gets logged
Brian> for this error, which is of little use, so let's avoid logging it
Brian> by default in order to avoid the log getting polluted with
Brian> useless data.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
