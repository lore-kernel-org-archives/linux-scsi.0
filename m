From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH] cxlflash: return -EFAULT if copy_from_user() fails
Date: Wed, 5 Jul 2017 12:56:44 -0500
Message-ID: <CA3F0E37-1B3F-4B7A-A544-C0EF3B826EDC@linux.vnet.ibm.com>
References: <20170630080106.yxyckztimezvpzrt@mwanda>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751784AbdGER4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 13:56:50 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v65HrjLd053217
        for <linux-scsi@vger.kernel.org>; Wed, 5 Jul 2017 13:56:49 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bh38kctd9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 13:56:49 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Wed, 5 Jul 2017 13:56:48 -0400
In-Reply-To: <20170630080106.yxyckztimezvpzrt@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


> On Jun 30, 2017, at 3:01 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> The copy_from/to_user() functions return the number of bytes remaining
> to be copied but we had intended to return -EFAULT here.
> 
> Fixes: bc88ac47d5cb ("scsi: cxlflash: Support AFU debug")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Good catch Dan!

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
