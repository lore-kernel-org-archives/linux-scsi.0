From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] hpsa updates
Date: Tue, 23 Feb 2016 21:03:13 -0500
Message-ID: <yq160xekgpq.fsf@sermon.lab.mkp.net>
References: <20160223210957.5968.6998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20227 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbcBXCDy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2016 21:03:54 -0500
In-Reply-To: <20160223210957.5968.6998.stgit@brunhilda> (Don Brace's message
	of "Tue, 23 Feb 2016 15:16:03 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> These patches are based on Linus's tree The changes are: - stop
Don> requesting enclosure info for external devices - add in SMR support
Don> - correct lun data caching macro definition - add abort support for
Don> hba devices - check for null pointer in ioaccel2 path - remove
Don> definition for sanitize_inquiry_string This patch depends on -
Don> commit ac10a3e4ed64 ("Export function
Don> scsi_scan.c:sanitize_inquiry_string") - update copyright
Don> information ---

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
