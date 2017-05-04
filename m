From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: pmcraid: remove redundant check to see if
 request_size is less than zero
Date: Thu, 4 May 2017 12:46:46 -0700
Message-ID: <79da6ab7-da2c-c1fc-e384-92d68028d091@linux.vnet.ibm.com>
References: <20170503162901.3623-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56692 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751808AbdEDTqx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2017 15:46:53 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v44Jhing071991
        for <linux-scsi@vger.kernel.org>; Thu, 4 May 2017 15:46:52 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2a89sr2jph-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 04 May 2017 15:46:52 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Thu, 4 May 2017 15:46:51 -0400
In-Reply-To: <20170503162901.3623-1-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On 05/03/2017 09:29 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The 2nd check to see if request_size is less than zero is redundant
> because the first check takes error exit path on this condition. So,
> since it is redundant, remove it.
> 
> Detected by CoverityScan, CID#146149 ("Logically Dead Code")
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
