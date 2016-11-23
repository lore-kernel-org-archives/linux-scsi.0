From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] lpfc: fix oops/BUG in lpfc_sli_ringtxcmpl_put()
Date: Wed, 23 Nov 2016 10:41:54 -0200
Message-ID: <c8516a1c-4a95-5e89-ad3a-84eb88272e19@linux.vnet.ibm.com>
References: <1479904399-19496-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53910 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935601AbcKWMnJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Nov 2016 07:43:09 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uANCdI7W055709
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2016 07:42:11 -0500
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 26w81evp64-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2016 07:42:11 -0500
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Wed, 23 Nov 2016 10:42:08 -0200
In-Reply-To: <1479904399-19496-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@broadcom.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Harsha Thyagaraja <hathyaga@in.ibm.com>

Due credit; an oversight.

On 11/23/2016 10:33 AM, Mauricio Faria de Oliveira wrote:

Reported-by: Harsha Thyagaraja <hathyaga@in.ibm.com>

> Cc: stable@vger.kernel.org # v4.8
> Fixes: 22466da5b4b7 ("lpfc: Fix possible NULL pointer dereference")
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>



-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center

