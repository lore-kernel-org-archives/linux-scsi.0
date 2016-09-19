From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND] [PATCH 1/1] ses: Retry UNIT ATTENTION for receive diagnostics
Date: Mon, 19 Sep 2016 11:57:06 -0400
Message-ID: <yq1eg4fann1.fsf@sermon.lab.mkp.net>
References: <20160916210607.054BF124047@b01ledav002.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30357 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbcISP5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 11:57:17 -0400
In-Reply-To: <20160916210607.054BF124047@b01ledav002.gho.pok.ibm.com> (Brian
        King's message of "Fri, 16 Sep 2016 16:06:06 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, krisman@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, stable@vger.kernel.org

>>>>> "Brian" == Brian King <brking@linux.vnet.ibm.com> writes:

Brian> If the ses driver receives a UNIT ATTENTION when issuing a
Brian> receive diagnostics while probing a SES device, it fails to
Brian> attach with messages such as:

Brian> scsi 1:0:7:0: Failed to get diagnostic page 0x8000002 scsi
Brian> 1:0:7:0: Failed to bind enclosure -19

Brian> Fix this by eating unit attentions for these commands.

James?

-- 
Martin K. Petersen	Oracle Linux Engineering
