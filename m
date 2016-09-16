From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ipr: Don't log unnecessary 9084 error details
Date: Fri, 16 Sep 2016 19:00:23 -0300
Message-ID: <87k2ebpkso.fsf@linux.vnet.ibm.com>
References: <20160916215136.9E5F8124047@b01ledav002.gho.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42625 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750945AbcIPWAa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Sep 2016 18:00:30 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8GLvPD4127312
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 18:00:30 -0400
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25gqe4bd7c-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 18:00:29 -0400
Received: from localhost
        by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
        Fri, 16 Sep 2016 19:00:27 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.18.232.225])
        by d24dlp01.br.ibm.com (Postfix) with ESMTP id C7005352005C
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 18:00:01 -0400 (EDT)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u8GM0Ops32178422
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 19:00:24 -0300
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
        by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u8GM0OYJ025311
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2016 19:00:24 -0300
In-Reply-To: <20160916215136.9E5F8124047@b01ledav002.gho.pok.ibm.com> (Brian
        King's message of "Fri, 16 Sep 2016 16:51:36 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

Brian King <brking@linux.vnet.ibm.com> writes:

> A 9084 error gets logged by the ipr adapter when adapter raw mode
> gets enabled. A bunch of unformatted hex data also gets logged
> for this error, which is of little use, so let's avoid logging
> it by default in order to avoid the log getting polluted with
> useless data.
>

Thanks, Brian.

Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>



-- 
Gabriel Krisman Bertazi

