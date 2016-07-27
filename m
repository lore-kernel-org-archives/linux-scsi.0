From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: fix oops in lpfc_sli4_scmd_to_wqidx_distr() from lpfc_send_taskmgmt()
Date: Wed, 27 Jul 2016 00:33:07 -0400
Message-ID: <yq1twfb66po.fsf@sermon.lab.mkp.net>
References: <1465341188-32620-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<yq1fur1bf5w.fsf@sermon.lab.mkp.net>
	<57963531.1070209@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49606 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbcG0Ehd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2016 00:37:33 -0400
In-Reply-To: <57963531.1070209@linux.vnet.ibm.com> (Mauricio Faria de
	Oliveira's message of "Mon, 25 Jul 2016 12:50:09 -0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, james.smart@broadcom.com, dick.kennedy@broadcom.com

>>>>> "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com> writes:

Mauricio> Can this be routed into stable?

Added a stable tag.

-- 
Martin K. Petersen	Oracle Linux Engineering
