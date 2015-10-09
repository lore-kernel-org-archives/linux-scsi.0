From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH v3 0/10] megaraid_sas : Updates for scsi for-next
Date: Fri, 9 Oct 2015 10:40:07 +0530
Message-ID: <8b3d1ba23ef04e1d71f1eb2c2e16cda9@mail.gmail.com>
References: <201508311158.t7VBwALp031354@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34238 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbbJIFKK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2015 01:10:10 -0400
Received: by lbbwt4 with SMTP id wt4so68744951lbb.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2015 22:10:08 -0700 (PDT)
In-Reply-To: <201508311158.t7VBwALp031354@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@avagotech.com>
Cc: Uday Lingala <uday.lingala@avagotech.com>

> -----Original Message-----
> From: sumit.saxena@avagotech.com [mailto:sumit.saxena@avagotech.com]
> Sent: Monday, August 31, 2015 5:23 PM
> To: linux-scsi@vger.kernel.org; thenzl@redhat.com;
> martin.petersen@oracle.com; hch@infradead.org; jbottomley@parallels.com;
> kashyap.desai@avagotech.com; sumit.saxena@avagotech.com; kiran-
> kumar.kasturi@avagotech.com
> Cc: uday.lingala@avagotech.com
> Subject: [PATCH v3 0/10] megaraid_sas : Updates for scsi for-next
>
> MegaRaid driver changes. This patch set is rebased on top of below
commit-
>
> commit da0dc9fb4e6b0ad5a947c27a3c48985f6a2377eb
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Tue Jul 7 15:52:45 2015 -0500
>
>     megaraid_sas: fix whitespace errors
>
>
> Please consider this patch set for next kernel release.

James,

Gentle reminder. Can you consider these patches?

Thanks,
Sumit
>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> ---
> [PATCH v3 00/10] megaraid_sas : Updates for scsi for-next.
> [PATCH v3 01/10] megaraid_sas : Synchronize driver headers with firmware
> APIs.
> [PATCH v3 02/10] megaraid_sas : Increase timeout to 60 secs for abort
frames
> during shutdown.
> [PATCH v3 03/10] megaraid_sas : Jbod sequence number support.
> [PATCH v3 04/10] megaraid_sas : Code cleanup-use local variable drv_ops
inside
> megasas_ioc_init_fusion.
> [PATCH v3 05/10] megaraid_sas : Support for max_io_size 1MB.
> [PATCH v3 06/10] megaraid_sas : Chip reset if driver fail to bring ioc
ready.
> [PATCH v3 07/10] megaraid_sas : Print critical fw event message.
> [PATCH v3 08/10] megaraid_sas : Fix validHandles check in io path.
> [PATCH v3 09/10] megaraid_sas : Code refactor for use of requestorId.
> [PATCH v3 10/10] megaraid_sas : Version upgrade.
>
