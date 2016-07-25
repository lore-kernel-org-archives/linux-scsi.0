From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH] lpfc: fix oops in lpfc_sli4_scmd_to_wqidx_distr() from
 lpfc_send_taskmgmt()
Date: Mon, 25 Jul 2016 12:50:09 -0300
Message-ID: <57963531.1070209@linux.vnet.ibm.com>
References: <1465341188-32620-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <yq1fur1bf5w.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3949 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751292AbcGYPuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2016 11:50:19 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6PFn44n075075
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2016 11:50:18 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
	by mx0b-001b2d01.pphosted.com with ESMTP id 24c2qvb0hk-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2016 11:50:17 -0400
Received: from localhost
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
	Mon, 25 Jul 2016 12:50:15 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 1E604352006E
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2016 11:49:54 -0400 (EDT)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
	by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6PFoDcd25231694
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2016 12:50:13 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
	by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6PFoCru000992
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2016 12:50:12 -0300
In-Reply-To: <yq1fur1bf5w.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, james.smart@broadcom.com, dick.kennedy@broadcom.com

On 07/22/2016 05:18 PM, Martin K. Petersen wrote:
> Applied to 4.8/scsi-queue.

Can this be routed into stable?

The 'Fixes:' commit was introduced in v4.2, and there's longterm v4.4
and stables v4.5 and v4.6 after that.

Given an oops (which may panic depending on configuration) got fixed,
and it happens in normal scenarios (eg SCSI EH), it seems appropriate.

Thanks,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center

