From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH][V2] scsi: qedf: fix spelling mistake: "offlading" ->
 "offloading"
Date: Wed, 5 Jul 2017 12:55:19 -0700
Message-ID: <8357b837-9f85-dda4-acb5-ae0efdf95342@linux.vnet.ibm.com>
References: <20170703192139.24314-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35027 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753405AbdGETz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2017 15:55:27 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v65JrfZX034255
        for <linux-scsi@vger.kernel.org>; Wed, 5 Jul 2017 15:55:26 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bgtyfr2q9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2017 15:55:26 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Wed, 5 Jul 2017 15:55:25 -0400
In-Reply-To: <20170703192139.24314-1-colin.king@canonical.com>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, QLogic-Storage-Upstream@cavium.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

On 07/03/2017 12:21 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake in QEDF_INFO message and 
> remove duplicated "since" (thanks to Tyrel Datwyler for spotting
> the latter issue).
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
