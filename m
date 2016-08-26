From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH -next] ibmvscsis: Use list_move_tail instead of
 list_del/list_add_tail
Date: Fri, 26 Aug 2016 10:50:16 -0500
Message-ID: <452DE6AD-C452-4480-983A-A755860C60D7@linux.vnet.ibm.com>
References: <1469196226-17333-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46031 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752985AbcHZRB4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 13:01:56 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7QFn4xS093738
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2016 11:50:21 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25231th8y4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2016 11:50:20 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Fri, 26 Aug 2016 09:50:19 -0600
In-Reply-To: <1469196226-17333-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 7/22/16, 9:03 AM, "Wei Yongjun" <target-devel-owner@vger.kernel.org on behalf of weiyj.lk@gmail.com> wrote:

    Using list_move_tail() instead of list_del() + list_add_tail().
    
    Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
    ---
     drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +--
     1 file changed, 1 insertion(+), 2 deletions(-)
    

Looks good to me.


