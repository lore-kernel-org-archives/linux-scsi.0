From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid-sas: request irqs later
Date: Tue, 15 Nov 2016 15:59:45 +0530
Message-ID: <2069a5360bb2b911283d00a6a74db9bb@mail.gmail.com>
References: <1478017922-22655-1-git-send-email-thenzl@redhat.com> <yq1wpg5ei8b.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:36418 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755484AbcKOK3w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 05:29:52 -0500
Received: by mail-it0-f49.google.com with SMTP id q124so162456242itd.1
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 02:29:51 -0800 (PST)
In-Reply-To: <yq1wpg5ei8b.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>

>-----Original Message-----
>From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
>Sent: Tuesday, November 15, 2016 5:18 AM
>To: Tomas Henzl
>Cc: linux-scsi@vger.kernel.org; sumit.saxena@broadcom.com;
>kashyap.desai@broadcom.com
>Subject: Re: [PATCH] megaraid-sas: request irqs later
>
>>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:
>
>Tomas> It is not good when an irq arrives before driver structures are
>Tomas> allocated.
>
>Sumit, Kashyap: Please review!

Looks good.. I think I have acked this patch earlier also.
Acked-by: Sumit Saxena<sumit.saxena@broadcom.com>
>
>--
>Martin K. Petersen	Oracle Linux Engineering
