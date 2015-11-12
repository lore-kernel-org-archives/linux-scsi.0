From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Clear PS bit before Mode Select.
Date: Wed, 11 Nov 2015 21:11:05 -0500
Message-ID: <yq1a8qkt1ae.fsf@sermon.lab.mkp.net>
References: <1446228283-32627-1-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33125 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbbKLCLO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2015 21:11:14 -0500
In-Reply-To: <1446228283-32627-1-git-send-email-krisman@linux.vnet.ibm.com>
	(Gabriel Krisman Bertazi's message of "Fri, 30 Oct 2015 16:04:43
	-0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, JBottomley@odin.com

>>>>> "Gabriel" == Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com> writes:

Gabriel> This patch clears the PS bit in the buffer returned by Mode
Gabriel> Select, right before it is used in the Mode Select command.

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
