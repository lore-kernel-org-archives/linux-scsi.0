From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: do not set DID_PASSTHROUGH on CHECK CONDITION
Date: Tue, 11 Apr 2017 11:48:40 -0300
Message-ID: <2bd87170-8196-9006-eeee-1f22bb950d75@linux.vnet.ibm.com>
References: <1491921964-11077-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752474AbdDKOsr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Apr 2017 10:48:47 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3BEmYpn121161
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 10:48:47 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29rf066eap-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 10:48:46 -0400
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Tue, 11 Apr 2017 11:48:44 -0300
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v3BEmgBe36831440
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 11:48:42 -0300
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
        by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v3BEmf9N025870
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2017 11:48:41 -0300
In-Reply-To: <1491921964-11077-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, brking@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

This is the PATCH v2.  Sorry for the wrong subject line.

On 04/11/2017 11:46 AM, Mauricio Faria de Oliveira wrote:
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> Acked-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> v2:
>  - use the scsi_cmd local variable rather than ipr_cmd->scsi_cmd dereference.
>  - add Acked-by: Brian King.


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
