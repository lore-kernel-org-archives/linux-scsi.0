From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCHv2] ipr: Add asynchronous error notification
Date: Thu, 25 Aug 2016 12:29:04 -0300
Message-ID: <87zio098an.fsf@linux.vnet.ibm.com>
References: <1469795977-6345-1-git-send-email-halves@linux.vnet.ibm.com>
        <yq1twehh3ty.fsf@sermon.lab.mkp.net>
        <a7eec861-46e1-4d82-1361-ae9b9a04cf3d@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61002 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758781AbcHYP3M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Aug 2016 11:29:12 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7PFQ4Vf063147
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2016 11:29:11 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2512h98e6b-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2016 11:29:11 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Thu, 25 Aug 2016 12:29:09 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
        by d24dlp02.br.ibm.com (Postfix) with ESMTP id 348101DC0051
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2016 11:28:57 -0400 (EDT)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u7PFT6LM4063676
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2016 12:29:06 -0300
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
        by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u7PFT5Rv030855
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2016 12:29:06 -0300
In-Reply-To: <a7eec861-46e1-4d82-1361-ae9b9a04cf3d@linux.vnet.ibm.com> (Brian
        King's message of "Wed, 24 Aug 2016 12:56:51 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Heitor Ricardo Alves de Siqueira <halves@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Heitor Ricardo Alves de Siqueira <hrasiq@gmail.com>

Brian King <brking@linux.vnet.ibm.com> writes:

> Looks pretty good. I noticed one issue in an error path where you
> weren't removing the new sysfs file. Here is a fixed version.
>

The modifications look good to me.


-- 
Gabriel Krisman Bertazi

