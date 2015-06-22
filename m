From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 01/20] [SCSI] mpt3sas: Added Combined Reply Queue feature to extend up-to 96 MSIX vector support
Date: Mon, 22 Jun 2015 16:37:25 -0400
Message-ID: <yq1a8vr7a4a.fsf@sermon.lab.mkp.net>
References: <1434711346-9970-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1vbejd9uf.fsf@sermon.lab.mkp.net>
	<CAK=zhgp2vf_CqLv+eG_RkZsCAD3P8dmFPYaYRArMiCgP-4ZpNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51943 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbbFVUiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 16:38:22 -0400
In-Reply-To: <CAK=zhgp2vf_CqLv+eG_RkZsCAD3P8dmFPYaYRArMiCgP-4ZpNQ@mail.gmail.com>
	(Sreekanth Reddy's message of "Mon, 22 Jun 2015 18:08:27 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, Johannes Thumshirn <jthumshirn@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> I will remove these extra brackets. but SAS3 HBA's less than
Sreekanth> C0 revision (which doesn't support this Combined Reply Queue
Sreekanth> feature) will support up to 16 MSI-X vectors.

Ah, I missed that. Fair enough.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
