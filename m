From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] ipr: Add new CCIN for new adapters support
Date: Tue, 12 Jul 2016 18:43:31 -0300
Message-ID: <87r3aya5x8.fsf@linux.vnet.ibm.com>
References: <1468357329-3790-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53697 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbcGLVnn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2016 17:43:43 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6CLd5aS085140
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:43:37 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
	by mx0a-001b2d01.pphosted.com with ESMTP id 2452xr3ksh-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:43:37 -0400
Received: from localhost
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Tue, 12 Jul 2016 18:43:35 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 2A91D352005F
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 17:43:14 -0400 (EDT)
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6CLhWms5017702
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 18:43:32 -0300
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
	by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6CLhVBa024682
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 18:43:32 -0300
In-Reply-To: <1468357329-3790-1-git-send-email-wenxiong@linux.vnet.ibm.com>
	(wenxiong@linux.vnet.ibm.com's message of "Tue, 12 Jul 2016 16:02:07
	-0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, JBottomley@Odin.com, martin.petersen@oracle.com, brking@linux.vnet.ibm.com

wenxiong@linux.vnet.ibm.com writes:

> From: Wen Xiong <wenxiong@linux.vnet.ibm.com>
>
> Add the appropriate definitions and table entries for new
> adapters support.
>
> Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>


-- 
Gabriel Krisman Bertazi

