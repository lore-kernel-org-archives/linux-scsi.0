From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH v1 1/3] Synchronization of cmds during termination
 conditions
Date: Wed, 12 Oct 2016 09:09:21 -0500
Message-ID: <0da9ea18-5dae-00d1-b969-85b71d2baf1c@linux.vnet.ibm.com>
References: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
 <1476226685-2276-2-git-send-email-mikecyr@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754762AbcJLOJd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Oct 2016 10:09:33 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9CE9Fid092663
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 10:09:33 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 261npbk8uc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 10:09:32 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Wed, 12 Oct 2016 08:09:30 -0600
In-Reply-To: <1476226685-2276-2-git-send-email-mikecyr@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Cyr <mikecyr@us.ibm.com>, nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com


On 10/11/16 5:58 PM, Michael Cyr wrote:
> Signed-off-by: Michael Cyr <mikecyr@us.ibm.com>
> ---
>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 1082 +++++++++++++-----------------
>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h |    5 +-
>   2 files changed, 486 insertions(+), 601 deletions(-)
>
>
I would make the first patch reorganization and styling fixes, no actual 
code changes.
Then for each of the commits make sure you amend them to give more 
description
as to what you are doing in each specific patch.

i.e. First patch:

ibmvscsis: Re-organization of commands/styling

Need to move functions around in order for the proceeding patches to work.

Patch 2/3 and 3/3 look fine to me after you change the title to include 
"ibmvscsis:" in it.

-Bryant

