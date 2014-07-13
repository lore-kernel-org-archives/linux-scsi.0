From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 01/10][SCSI]mpt2sas: Added driver module parameter max_msix_vectors
Date: Sun, 13 Jul 2014 10:54:40 -0400
Message-ID: <yq1egxpz4un.fsf@sermon.lab.mkp.net>
References: <20140625103028.GA12870@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18477 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbaGMOzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jul 2014 10:55:15 -0400
In-Reply-To: <20140625103028.GA12870@avagotech.com> (Sreekanth Reddy's message
	of "Wed, 25 Jun 2014 16:00:28 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Cc: jejb@kernel.org, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com

>>>>> "Sreekanth" == Reddy, Sreekanth <Sreekanth.Reddy@avagotech.com> writes:

Sreekanth> Added driver module parameter max_msix_vectors. Using this
Sreekanth> module parameter the maximum number of MSI-X vectors could be
Sreekanth> set.

Sreekanth> The number of MSI-X vectors used would be the minimum of
Sreekanth> MSI-X vectors supported by the HBA, the number of CPU cores
Sreekanth> and the value set to max_msix_vectors module parameters.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
