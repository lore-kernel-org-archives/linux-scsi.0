From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] sd_try_extended_inquiry for SPC-3 targets
Date: Tue, 21 May 2013 15:33:28 -0400
Message-ID: <yq1zjvo5drr.fsf@sermon.lab.mkp.net>
References: <35421216.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25091 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3EUTdK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 May 2013 15:33:10 -0400
In-Reply-To: <35421216.post@talk.nabble.com> (Ilan Steinberg's message of
	"Tue, 21 May 2013 06:40:56 -0700 (PDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ilan Steinberg <ilan.steinberg@kaminario.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Ilan" == Ilan Steinberg <ilan.steinberg@kaminario.com> writes:

Ilan> If you read the comment it seams to me that the test
Ilan> (sdp->scsi_level > SCSI_SPC_2) is incorrect.

scsi_device->scsi_level is not in sync with SPC-n. We set scsi_level
to match the offset Linux constants at device discovery time.

Did you remember to include the Block Device Characteristics VPD page in
your page 0?

-- 
Martin K. Petersen	Oracle Linux Engineering
