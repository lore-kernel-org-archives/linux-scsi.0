From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [2.6 patch] SCSI: possible cleanups
Date: Tue, 1 Mar 2005 07:36:15 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BD63E10@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:7104 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261887AbVCAMgT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 07:36:19 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mark Haverkamp <markh@osdl.org>

Christoph Hellwig writes:
>>   - scsi_scan.c: scsi_rescan_device
>aacraid was going to use that one, Mark, any chance to get a patch
anytime soon?
>>   - scsi_scan.c: scsi_scan_single_target
>as mentioned above we'll need this one soon.

Yup, we use both of them in our branch of the driver. I submit a patch
to MarkH for the Hot-Add calls soon.

Sincerely -- Mark Salyzyn

