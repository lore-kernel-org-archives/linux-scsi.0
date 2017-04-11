From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: do not set DID_PASSTHROUGH on CHECK CONDITION
Date: Tue, 11 Apr 2017 11:40:23 -0300
Message-ID: <37de530e-118d-ec21-53e6-e6e72352c5e7@linux.vnet.ibm.com>
References: <1491877731-19287-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <195c1f0d-2ff5-a54f-a51d-f595b8673be6@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59848 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751248AbdDKOkf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Apr 2017 10:40:35 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3BEdFRg027918
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 10:40:35 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0b-001b2d01.pphosted.com with ESMTP id 29rxx2fd6t-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 10:40:34 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Tue, 11 Apr 2017 11:40:32 -0300
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3BEeULb5177778
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 11:40:30 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
        by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v3BEeSWD016173
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 11:40:28 -0300
In-Reply-To: <195c1f0d-2ff5-a54f-a51d-f595b8673be6@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com

On 04/11/2017 11:34 AM, Brian King wrote:
> Looks good to me. Thanks for the detailed analysis. One minor nit below
> and you can add:
>
> Acked-by: Brian King <brking@linux.vnet.ibm.com>

Cool, thanks. I'll submit a v2.

> Since we already have a scsi_cmd local, you don't need to go back to the ipr_cmd
> to get the pointer, so could be:

Thanks for catching that oversight.


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
