From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: RE: [PATCH v4 00/17] be2iscsi: driver update 11.0.0.0
Date: Wed, 27 Jan 2016 13:49:53 +0530
Message-ID: <a9722d8a121c76ad11eb2bb05a03f109@mail.gmail.com>
References: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com> <yq1wpqviymr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:36153 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbcA0IUG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2016 03:20:06 -0500
Received: by mail-yk0-f178.google.com with SMTP id v14so232060639ykd.3
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2016 00:20:06 -0800 (PST)
In-Reply-To: <yq1wpqviymr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Wednesday, January 27, 2016 7:15 AM
> To: Jitendra Bhivare
> Cc: linux-scsi@vger.kernel.org; michaelc@cs.wisc.edu
> Subject: Re: [PATCH v4 00/17] be2iscsi: driver update 11.0.0.0
>
> >>>>> "Jitendra" == Jitendra Bhivare <jitendra.bhivare@avagotech.com>
writes:
>
> Applied to 4.6/scsi-queue.
>
> PATCH 12/17: "be2iscsi: Fix IOPOLL implementation" conflicted with
Christoph's
> irq_poll changes. I fixed it up but please verify:
>
>
http://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/commit/?h=4.6/scs
i-
> queue&id=fa512e1a3156
>
> --
> Martin K. Petersen	Oracle Linux Engineering
Reviewed by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Thanks,

JB
