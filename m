From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ipr: Increase MSIX vectors number
Date: Tue, 12 Jul 2016 18:44:43 -0300
Message-ID: <87mvlma5v8.fsf@linux.vnet.ibm.com>
References: <1468357329-3790-1-git-send-email-wenxiong@linux.vnet.ibm.com>
	<1468357329-3790-2-git-send-email-wenxiong@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3477 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbcGLVpA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2016 17:45:00 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6CLi6kM091165
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:44:50 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24507batrw-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:44:49 -0400
Received: from localhost
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Tue, 12 Jul 2016 18:44:47 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id D6DD41DC0054
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:44:36 -0400 (EDT)
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6CLiiJ14276240
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 18:44:44 -0300
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
	by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6CLiiXZ026497
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 18:44:44 -0300
In-Reply-To: <1468357329-3790-2-git-send-email-wenxiong@linux.vnet.ibm.com>
	(wenxiong@linux.vnet.ibm.com's message of "Tue, 12 Jul 2016 16:02:08
	-0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, JBottomley@Odin.com, martin.petersen@oracle.com, brking@linux.vnet.ibm.com

wenxiong@linux.vnet.ibm.com writes:

> From: Wen Xiong <wenxiong@linux.vnet.ibm.com>
>
> Increase MSIX vectors from 2 to 16 by default.
>
> Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> ---

Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Thanks,

-- 
Gabriel Krisman Bertazi

