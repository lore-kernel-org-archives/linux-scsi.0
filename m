From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] lpfc: support for CPU phys_id and core_id on
 PowerPC64
Date: Wed, 22 Jun 2016 09:51:56 -0300
Message-ID: <576A89EC.2010003@linux.vnet.ibm.com>
References: <1464813809-22066-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <201606012043.u51KflcX004680@mx0a-001b2d01.pphosted.com>
 <20160621142902.GA10597@infradead.org> <57697C71.3060109@linux.vnet.ibm.com>
 <yq1fus62cji.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60567 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbcFVMwT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2016 08:52:19 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5MCn8WW092850
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2016 08:52:08 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23q1qnuhmd-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2016 08:52:08 -0400
Received: from localhost
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
	Wed, 22 Jun 2016 09:52:06 -0300
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 07E741DC006E
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2016 08:51:54 -0400 (EDT)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
	by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u5MCq1Ci4755612
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2016 09:52:01 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
	by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u5MCq0Yi014162
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jun 2016 09:52:01 -0300
In-Reply-To: <yq1fus62cji.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, dick.kennedy@broadcom.com, james.smart@broadcom.com

Hi Martin,

On 06/21/2016 11:16 PM, Martin K. Petersen wrote:
> Distros are free to carry a patch such as yours. That puts the burden on
> them and not on upstream which is going in a different direction as
> outlined by Christoph.

> This is ultimately Broadcom's decision. It is their driver.

Right, I understand.  I submitted the patch in case they see value in
having it upstream, as some distros discuss/ask about what's the status
(or differences to) upstream.

In some cases, a rationale like this one being documented on a mailing
list is sufficient, provided the patch hasn't received other technical
problems, for example.

Thanks for the review/comments (Christoph too),

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center

