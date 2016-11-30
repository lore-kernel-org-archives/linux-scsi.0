From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH][V2] scsi: megaraid-sas: fix spelling mistake of "outstanding"
Date: Wed, 30 Nov 2016 10:47:03 +0530
Message-ID: <0224a6a40ed0aaebfa88d9a82aae5125@mail.gmail.com>
References: <20161129191333.9176-1-colin.king@canonical.com> <99f3f833-6dd6-557a-2ae4-0051dfbe9f36@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:36111 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751382AbcK3FRF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2016 00:17:05 -0500
Received: by mail-qt0-f173.google.com with SMTP id w33so177630059qtc.3
        for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2016 21:17:05 -0800 (PST)
In-Reply-To: <99f3f833-6dd6-557a-2ae4-0051dfbe9f36@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Colin King <colin.king@canonical.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sasikumar PC <sasikumar.pc@broadcom.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>

> -----Original Message-----
> From: Bart Van Assche [mailto:bart.vanassche@sandisk.com]
> Sent: Wednesday, November 30, 2016 12:50 AM
> To: Colin King; Kashyap Desai; Sumit Saxena; Shivasharan S; James E . J .
> Bottomley; Martin K . Petersen; megaraidlinux.pdl@broadcom.com; linux-
> scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: [PATCH][V2] scsi: megaraid-sas: fix spelling mistake of
> "outstanding"
>
> On 11/29/2016 11:13 AM, Colin King wrote:
> > Trivial fix to spelling mistake "oustanding" to "outstanding" in
> > dev_info and scmd_printk messages. Also join wrapped literal string in
> > the scmd_printk.
>
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

Please hold this commit as we have patch set work in progress for MegaRaid
Driver. It will conflict it this patch commits.
We will be re-submitting this patch with appropriate Signed-off and
Submitted-by tags.

Thanks, Kashyap
