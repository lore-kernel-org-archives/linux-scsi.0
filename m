From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 16/20] [SCSI] mpt3sas: Added support for customer specific branding
Date: Mon, 22 Jun 2015 16:36:29 -0400
Message-ID: <yq1egl37a5u.fsf@sermon.lab.mkp.net>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-17-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1k2uza0n5.fsf@sermon.lab.mkp.net>
	<CAK=zhgoY6s1hVzWnPKTf0iMKoFJeJ+D6xcXFAf1mQLAHMSiZ4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44806 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbFVUhM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 16:37:12 -0400
In-Reply-To: <CAK=zhgoY6s1hVzWnPKTf0iMKoFJeJ+D6xcXFAf1mQLAHMSiZ4g@mail.gmail.com>
	(Sreekanth Reddy's message of "Mon, 22 Jun 2015 17:56:58 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> I agree with you that these changes belong in pci.ids. But
Sreekanth> Customers are asking us to print the HBA branding name while
Sreekanth> loading the driver on their custom HBA's.

Yes, and other HBA vendors have done the same (although thankfully this
practice appears to be going out of fashion).

Personally, I find SAS2308 orders of magnitude more useful and helpful
than WHIZ-BANG2010 since the former tells me exactly what chip I'm
dealing with.

Anyway. No big deal. I just think it's a bad habit to use the kernel for
marketing purposes.

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
