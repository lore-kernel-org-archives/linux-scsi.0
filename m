From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 01/16] lpfc: Correct WQ creation for pagesize
Date: Tue, 7 Mar 2017 09:46:12 -0300
Message-ID: <3a13b77f-a60f-0c7e-dddf-5d8b87740b4e@linux.vnet.ibm.com>
References: <58a0d919.08BhoypOnvRSLIqV%jsmart2021@gmail.com>
 <6a197069-2f10-6df1-4cf1-1a62808c8903@linux.vnet.ibm.com>
 <yq1tw75kbdn.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57575 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754797AbdCGMqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2017 07:46:44 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v27CcXsE145632
        for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2017 07:46:21 -0500
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 291vja1ybu-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 07 Mar 2017 07:46:21 -0500
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Tue, 7 Mar 2017 09:46:18 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.18.232.225])
        by d24dlp02.br.ibm.com (Postfix) with ESMTP id 89F8E1DC0054
        for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2017 07:46:16 -0500 (EST)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v27CkEPB37290096
        for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2017 09:46:15 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
        by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v27CkEj0015383
        for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2017 09:46:15 -0300
In-Reply-To: <yq1tw75kbdn.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me

Hi Martin,

On 03/07/2017 12:35 AM, Martin K. Petersen wrote:
> Mauricio> Please flag this patch for stable.

> Both patches are already upstream so I can't tag them for stable. Either
> you or James should mail stable@vger.kernel.org and request for the
> patches to be queued up.

Right, sorry; I missed checking the right tree. Thanks for the pointers.


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
