From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] ipr: Remove redundant messages at adapter init time
Date: Mon, 19 Sep 2016 11:59:01 -0400
Message-ID: <yq160pranju.fsf@sermon.lab.mkp.net>
References: <20160916215137.7DE02B204E@b01ledav03.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32217 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbcISP7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 11:59:23 -0400
In-Reply-To: <20160916215137.7DE02B204E@b01ledav03.gho.pok.ibm.com> (Brian
        King's message of "Fri, 16 Sep 2016 16:51:37 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> Whenever multiple HRRQs are enabled, which is the default setting
Brian> now, we end up seeing the following message logged prior to
Brian> initialization of each HRRQ:

Brian> Starting IOA initialization sequence

Brian> This results in 16 of these messages on most adapters, which
Brian> serves little purpose. Change to just log this once.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
