From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] cxlflash: drop unlikely before IS_ERR_OR_NULL
Date: Thu, 10 Dec 2015 12:56:05 -0500
Message-ID: <yq1d1ue2nnu.fsf@sermon.lab.mkp.net>
References: <1449177529-58863-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33659 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbbLJR4W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2015 12:56:22 -0500
In-Reply-To: <1449177529-58863-1-git-send-email-mrochs@linux.vnet.ibm.com>
	(Matthew R. Ochs's message of "Thu, 3 Dec 2015 15:18:49 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Geliang Tang <geliangtang@163.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, Michael Neuling <mikey@neuling.org>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Matthew" == Matthew R Ochs <mrochs@linux.vnet.ibm.com> writes:

Matthew> IS_ERR_OR_NULL already contain an unlikely compiler flag. Drop
Matthew> it.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
