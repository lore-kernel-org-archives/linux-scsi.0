From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ipr: Remove redundant messages at adapter init time
Date: Fri, 16 Sep 2016 19:00:47 -0300
Message-ID: <87fuozpks0.fsf@linux.vnet.ibm.com>
References: <20160916215137.7DE02B204E@b01ledav03.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43299 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750945AbcIPWAy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Sep 2016 18:00:54 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8GLvOj5127230
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 18:00:53 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25gqe4bdnh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 18:00:53 -0400
Received: from localhost
        by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Fri, 16 Sep 2016 19:00:51 -0300
Received: from d24relay04.br.ibm.com (d24relay04.br.ibm.com [9.18.232.146])
        by d24dlp02.br.ibm.com (Postfix) with ESMTP id 01F131DC006E
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 18:00:49 -0400 (EDT)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u8GM0mqq39190652
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 19:00:48 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u8GM0mnO018756
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 19:00:48 -0300
In-Reply-To: <20160916215137.7DE02B204E@b01ledav03.gho.pok.ibm.com> (Brian
        King's message of "Fri, 16 Sep 2016 16:51:37 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

Brian King <brking@linux.vnet.ibm.com> writes:

> Whenever multiple HRRQs are enabled, which is the default
> setting now, we end up seeing the following message logged
> prior to initialization of each HRRQ:
>
> Starting IOA initialization sequence
>
> This results in 16 of these messages on most adapters, which
> serves little purpose. Change to just log this once.


Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>


-- 
Gabriel Krisman Bertazi

