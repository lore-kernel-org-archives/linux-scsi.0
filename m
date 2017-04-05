From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] scsi: ses: don't get power status of SES device slot
 on probe
Date: Wed, 5 Apr 2017 14:22:58 -0300
Message-ID: <82aeb399-f3d6-4d7a-2b6f-5e7eef448790@linux.vnet.ibm.com>
References: <1491405499-5429-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <D1CDB51B-F034-4476-A709-E13B4C9682F7@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41265 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754389AbdDERYJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 13:24:09 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v35HJ0DZ050006
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 13:24:08 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29n34ce0v5-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 05 Apr 2017 13:24:08 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 5 Apr 2017 14:24:06 -0300
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v35HNULa27263202
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 14:23:44 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
        by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v35HNDPP027024
        for <linux-scsi@vger.kernel.org>; Wed, 5 Apr 2017 14:23:13 -0300
In-Reply-To: <D1CDB51B-F034-4476-A709-E13B4C9682F7@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@fb.com>, "hare@suse.de" <hare@suse.de>, "hch@lst.de" <hch@lst.de>, gpiccoli@linux.vnet.ibm.com

On 04/05/2017 01:23 PM, Song Liu wrote:
> Reviewed-by: Song Liu <songliubraving@fb.com>

Thanks for reviewing, Song Liu.

It's good to know this patch doesn't break anything for you.

cheers,


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
