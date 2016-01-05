From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/3] hpsa update
Date: Mon, 04 Jan 2016 20:59:15 -0500
Message-ID: <yq1poxglrbg.fsf@sermon.lab.mkp.net>
References: <20151222163508.16655.97012.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25567 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbcAEB7x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2016 20:59:53 -0500
In-Reply-To: <20151222163508.16655.97012.stgit@brunhilda> (Don Brace's message
	of "Tue, 22 Dec 2015 10:36:29 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@pmcs.com> writes:

Don> These patches are based on Linus's tree The changes are: - correct
Don> missing changes from snprintf to scnprintf in path_info_show by
Don> Rasmus Villemoes - fix reported bus for SAS transport devices - add
Don> in enclosure information

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
