From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH v2 0/10] megaraid_sas : Updates for scsi for-next
Date: Fri, 18 Sep 2015 14:35:24 +0530
Message-ID: <f68a703e08f7ebcdbb801999af12e45e@mail.gmail.com>
References: <201508201319.t7KDJDpc028522@palmhbs0.lsi.com> <1440790370.2202.46.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34787 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbbIRJHN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2015 05:07:13 -0400
Received: by lbbmp1 with SMTP id mp1so22006222lbb.1
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2015 02:07:11 -0700 (PDT)
In-Reply-To: <1440790370.2202.46.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Bjorn Helgaas <bhelgaas@google.com>

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Saturday, August 29, 2015 1:03 AM
> To: Sumit.Saxena@avagotech.com
> Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
> martin.petersen@oracle.com; hch@infradead.org; jbottomley@parallels.com;
> kashyap.desai@avagotech.com; kiran-kumar.kasturi@avagotech.com;
> uday.lingala@avagotech.com; Bjorn Helgaas
> Subject: Re: [PATCH v2 0/10] megaraid_sas : Updates for scsi for-next
>
> On Thu, 2015-08-20 at 18:43 +0530, Sumit.Saxena@avagotech.com wrote:
> > MegaRaid driver changes. This patch set is resent based on feedback
> > received
> by Martin Petersen.
> > Please consider this patch set for next kernel release.
> >
> > Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> > Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> > ---
> > [PATCH v2 00/10] megaraid_sas : Updates for scsi for-next.
> > [PATCH v2 01/10] megaraid_sas : Synchronize driver headers with firmware
> APIs.
> > [PATCH v2 02/10] megaraid_sas : Increase timeout to 60 secs for abort
> > frames
> during shutdown.
> > [PATCH v2 03/10] megaraid_sas : Jbod sequence number support.
> > [PATCH v2 04/10] megaraid_sas : Code cleanup-use local variable drv_ops
> inside megasas_ioc_init_fusion.
> > [PATCH v2 05/10] megaraid_sas : Support for max_io_size 1MB.
> > [PATCH v2 06/10] megaraid_sas : Chip reset if driver fail to bring ioc
> > ready.
> > [PATCH v2 07/10] megaraid_sas : Print critical fw event message.
> > [PATCH v2 08/10] megaraid_sas : Fix validHandles check in io path.
> > [PATCH v2 09/10] megaraid_sas : Code refactor for use of requestorId.
> > [PATCH v2 10/10] megaraid_sas : Version upgrade.
>
> I'm getting a ton of rejects in this series because of
>
> commit da0dc9fb4e6b0ad5a947c27a3c48985f6a2377eb
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Tue Jul 7 15:52:45 2015 -0500
>
>     megaraid_sas: fix whitespace errors
>
> Please fix.
>
> Useful rules of thumb are don't ack whitespace patches because they
> inevitably
> cause this type of issue.  If you do decide to ack, make sure you don't
> cause
> conflicts with your own outstanding patches.
>
> James

James,
I have sent patches rebased on latest code few days back. Can you provide
your feedback?

Thanks,
Sumit
>
>
