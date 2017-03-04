From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 10/11] lpfc: Add missing memory barrier
Date: Fri, 3 Mar 2017 22:46:13 -0300
Message-ID: <119bfea5-e903-ed2d-0a5d-a461a82dcf0e@linux.vnet.ibm.com>
References: <58586832.woeJM8e1raA2NxNi%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751551AbdCDBqw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2017 20:46:52 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v241hhMn147920
        for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2017 20:46:51 -0500
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28xs8fj6qx-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2017 20:46:51 -0500
Received: from localhost
        by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Fri, 3 Mar 2017 22:46:49 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.18.232.225])
        by d24dlp02.br.ibm.com (Postfix) with ESMTP id 545531DC0054
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2017 20:46:48 -0500 (EST)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v241kfrw34603070
        for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2017 22:46:46 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v241kQAo005001
        for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2017 22:46:26 -0300
In-Reply-To: <58586832.woeJM8e1raA2NxNi%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 12/19/2016 09:07 PM, James Smart wrote:
> On loosely ordered memory systems (PPC for example), the WQE elements
> were being updated in memory, but not necessarily flushed before the
> separate doorbell was written to hw which would cause hw to dma the
> WQE element. Thus, the hardware occasionally received partially
> updated WQE data.
>
> Add the memory barrier after updating the WQE memory.

Reviewed-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>

Martin, may you please flag this patch for stable?

Thank you,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
