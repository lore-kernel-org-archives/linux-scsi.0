From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Tue, 7 Mar 2017 09:51:14 -0300
Message-ID: <b7bac920-2ebe-a2fb-b775-c5a4381fe92e@linux.vnet.ibm.com>
References: <20170212214920.28866-1-anton@ozlabs.org>
 <e13aeaf9-3b2c-a9e8-5867-cf9ab20a040c@linux.vnet.ibm.com>
 <yq1lgshkau0.fsf@oracle.com> <1488864262.2870.149.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47233 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755400AbdCGMvY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2017 07:51:24 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v27Cmgqm068812
        for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2017 07:51:22 -0500
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0a-001b2d01.pphosted.com with ESMTP id 291w4w88ka-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 07 Mar 2017 07:51:22 -0500
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Tue, 7 Mar 2017 09:51:19 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.18.232.42])
        by d24dlp01.br.ibm.com (Postfix) with ESMTP id 248D2352006E
        for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2017 07:50:42 -0500 (EST)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v27CpGu627852908
        for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2017 09:51:16 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v27CpEaP028078
        for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2017 09:51:15 -0300
In-Reply-To: <1488864262.2870.149.camel@kernel.crashing.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anton Blanchard <anton@ozlabs.org>, james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

Martin,

On 03/07/2017 02:24 AM, Benjamin Herrenschmidt wrote:

> On Mon, 2017-03-06 at 22:46 -0500, Martin K. Petersen wrote:
>> I don't recall a consensus being reached on this patch.

> What would be the opposition ? Without it kexec breaks. With it, it
> works ...

That is the argument I'd present/ask for consideration too.

I think I should have included this in the tested-by tag email, for
documentation/evidence: no regression observed in system shutdown path.

Thanks,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
