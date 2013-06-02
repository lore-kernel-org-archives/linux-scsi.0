From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3 0/6] scsi_debug: bug fixes and cleanups for data
 integrity support
Date: Sun, 2 Jun 2013 11:51:10 +0900
Message-ID: <CAC5umyiW02vB-bbhCic=zU8CxaQY-AebQ0PCj1eTCifAUHortg@mail.gmail.com>
References: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
	<51A5057F.9030703@interlog.com>
	<yq1k3mi3nby.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:61428 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3FBCvL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Jun 2013 22:51:11 -0400
Received: by mail-oa0-f42.google.com with SMTP id i10so527237oag.29
        for <linux-scsi@vger.kernel.org>; Sat, 01 Jun 2013 19:51:10 -0700 (PDT)
In-Reply-To: <yq1k3mi3nby.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

2013/5/29 Martin K. Petersen <martin.petersen@oracle.com>:
> I have some patches pending as part of my next DIF/DIX update that makes
> some of these things more palatable at the block/SCSI level. Akinobu
> voiced interest in finishing the scsi_debug work on top of my code.

Yes.  I'm interested in that work.  Before I start working on it, I would
like to fix the problems which I found recently with virtual_gb option in
scsi_debug.  Because the change is not small and may touch the DIX/DIF
support code, too.

So Martin and Douglas, can I have your ACKs on this patch series for now?
