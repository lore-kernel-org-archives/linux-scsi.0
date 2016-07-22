From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: fix oops in lpfc_sli4_scmd_to_wqidx_distr() from lpfc_send_taskmgmt()
Date: Fri, 22 Jul 2016 16:18:03 -0400
Message-ID: <yq1fur1bf5w.fsf@sermon.lab.mkp.net>
References: <1465341188-32620-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25897 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbcGVUSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2016 16:18:11 -0400
In-Reply-To: <1465341188-32620-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	(Mauricio Faria de Oliveira's message of "Tue, 7 Jun 2016 20:13:08
	-0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, james.smart@broadcom.com, dick.kennedy@broadcom.com

>>>>> "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

Mauricio> The lpfc_sli4_scmd_to_wqidx_distr() function expects the
Mauricio> scsi_cmnd 'lpfc_cmd->pCmd' not to be null, and point to the
Mauricio> midlayer command.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
