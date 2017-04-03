From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [REGRESSION] v4.11-rc3: lpfc: panic during module removal /
 shutdown
Date: Mon, 3 Apr 2017 18:53:37 -0300
Message-ID: <9110d410-8522-9806-8444-44276de9af51@linux.vnet.ibm.com>
References: <99ad422f-8233-ddac-2e69-deda4a43b3d7@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51188 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751384AbdDCVx4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 17:53:56 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v33LrrZm098786
        for <linux-scsi@vger.kernel.org>; Mon, 3 Apr 2017 17:53:56 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29kubng5n3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 03 Apr 2017 17:53:55 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Mon, 3 Apr 2017 18:53:46 -0300
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
        by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v33Lri9O34406562
        for <linux-scsi@vger.kernel.org>; Mon, 3 Apr 2017 18:53:44 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
        by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v33Lrhbs002741
        for <linux-scsi@vger.kernel.org>; Mon, 3 Apr 2017 18:53:43 -0300
In-Reply-To: <99ad422f-8233-ddac-2e69-deda4a43b3d7@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-scsi <linux-scsi@vger.kernel.org>, "dick.kennedy@broadcom.com" <dick.kennedy@broadcom.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>
Cc: "anton@samba.org" <anton@samba.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

Hi Junichi,

On 03/28/2017 11:29 PM, Junichi Nomura wrote:
> Since commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications"),
> "rmmod lpfc" starting to cause panic or corruption due to double free.

Thanks for the report. Can you please check whether the patch just sent
([PATCH] lpfc: fix double free of bound CQ/WQ ring pointer) resolves it?

I don't have a setup to test it handy right now.

cheers,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
