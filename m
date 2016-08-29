From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH -next] ibmvscsis: Use list_move_tail instead of
 list_del/list_add_tail
Date: Mon, 29 Aug 2016 12:16:22 -0700
Message-ID: <57C48A06.4000806@linux.vnet.ibm.com>
References: <1469196226-17333-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36872 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751983AbcH2TQa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Aug 2016 15:16:30 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7TJDrAl083199
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2016 15:16:29 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 253r8t6ef1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2016 15:16:29 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Mon, 29 Aug 2016 15:16:28 -0400
In-Reply-To: <1469196226-17333-1-git-send-email-weiyj.lk@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>, "Bryant G . Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 07/22/2016 07:03 AM, Wei Yongjun wrote:
> Using list_move_tail() instead of list_del() + list_add_tail().
> 
> Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>

Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

