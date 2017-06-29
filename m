From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: ibmvscsi: constify dev_pm_ops structures.
Date: Thu, 29 Jun 2017 15:38:30 -0700
Message-ID: <a71efdaf-78d0-9a36-c358-3c2719dbcdec@linux.vnet.ibm.com>
References: <ff2eee2670f773454efdece4f455bb367fff3baa.1498722090.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751532AbdF2Wil (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jun 2017 18:38:41 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5TMceG8143368
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2017 18:38:40 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bd40jgb37-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2017 18:38:40 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
        Thu, 29 Jun 2017 18:38:39 -0400
In-Reply-To: <ff2eee2670f773454efdece4f455bb367fff3baa.1498722090.git.arvind.yadav.cs@gmail.com>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, tyreld@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org

On 06/29/2017 12:43 AM, Arvind Yadav wrote:
> dev_pm_ops are not supposed to change at runtime. All functions
> working with dev_pm_ops provided by <linux/device.h> work with const
> dev_pm_ops. So mark the non-const structs as const.
> 
> File size before:
>    text	   data	    bss	    dec	    hex	filename
>   17956	   1456	      8	  19420	   4bdc	drivers/scsi/ibmvscsi/ibmvscsi.o
> 
> File size After adding 'const':
>    text	   data	    bss	    dec	    hex	filename
>   18164	   1264	      8	  19436	   4bec	drivers/scsi/ibmvscsi/ibmvscsi.o
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
