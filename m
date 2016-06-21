From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] lpfc: PowerPC64 topology information, and per-core
 scheduling
Date: Tue, 21 Jun 2016 10:42:12 -0300
Message-ID: <57694434.1010606@linux.vnet.ibm.com>
References: <201606012043.u51KdPlB044752@mx0a-001b2d01.pphosted.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53318 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbcFUNmr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2016 09:42:47 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5LDgBo1021696
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2016 09:42:29 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23n2u7e3pa-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2016 09:42:29 -0400
Received: from localhost
	by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
	Tue, 21 Jun 2016 10:42:25 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id C0D333520070
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2016 09:42:00 -0400 (EDT)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
	by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u5LDgGZ95898606
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2016 10:42:16 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
	by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u5LDgGXZ009711
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2016 10:42:16 -0300
In-Reply-To: <201606012043.u51KdPlB044752@mx0a-001b2d01.pphosted.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com

On 06/01/2016 05:43 PM, Mauricio Faria de Oliveira wrote:
> Tested on next-20160601 (with an extra commit for patch 1/2, see commit msg).

FYI, that commit has been accepted into powerpc next [1].

[1] https://git.kernel.org/powerpc/c/f8ab481066e7246e4b272233aa

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center

