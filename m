From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH] megaraid_sas: Fix probing cards without io port
Date: Tue, 9 Aug 2016 23:22:12 +0530
Message-ID: <240effe70dbbcd5803e70163aacbe57a@mail.gmail.com>
References: <20160806063734.31083-1-yinghai@kernel.org> <yq1bn12u2at.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:34140 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbcHIRwe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 13:52:34 -0400
Received: by mail-qk0-f181.google.com with SMTP id p186so20276115qkd.1
        for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2016 10:52:14 -0700 (PDT)
In-Reply-To: <yq1bn12u2at.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 > > that does not io port resource allocated from BIOS, and kernel can
not
> > assign one as io port shortage.
> >
> > The driver is only looking for MEM, and should not fail.
>
> > It turns out megasas_init_fw() etc are using bar index as mask.
> > index 1 is used as mask 1, so that pci_request_selected_regions() is
> > trying to request BAR0 instead of BAR1.
>
> > Fix all related reference.

Review patch and looks good. Thanks Yinghai for submitting patch.

Acked-by:  Kashyap Desai <kashyap.desai@broadcom.com>

>
> Kashyap? Sumit?
>
> --
> Martin K. Petersen	Oracle Linux Engineering
