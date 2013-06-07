From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/6] scsi_debug: bug fixes and cleanups for data integrity support
Date: Thu, 06 Jun 2013 22:35:50 -0400
Message-ID: <yq1y5ammyux.fsf@sermon.lab.mkp.net>
References: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
	<51A5057F.9030703@interlog.com> <yq1k3mi3nby.fsf@sermon.lab.mkp.net>
	<CAC5umyiW02vB-bbhCic=zU8CxaQY-AebQ0PCj1eTCifAUHortg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26182 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3FGCfd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jun 2013 22:35:33 -0400
In-Reply-To: <CAC5umyiW02vB-bbhCic=zU8CxaQY-AebQ0PCj1eTCifAUHortg@mail.gmail.com>
	(Akinobu Mita's message of "Sun, 2 Jun 2013 11:51:10 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> So Martin and Douglas, can I have your ACKs on this patch
Akinobu> series for now?

Only concern is the one I mentioned before: You're mapping and unmapping
the ppage for every 8 bytes of protection information. That seems a bit
excessive.

However, I personally don't care too much about 32-bit platforms, so...

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
