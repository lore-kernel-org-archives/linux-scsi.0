From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ata: xgene: Enable NCQ support for APM X-Gene SATA
 controller hardware v1.1
Date: Wed, 9 Nov 2016 11:45:31 -0500
Message-ID: <20161109164531.GA14630@htj.duckdns.org>
References: <1469524857-3720-1-git-send-email-rsahu@apm.com>
 <CAFd313x-mXpy0N3aKx2rfoag1FNOrN-LzKb5UHkY2L+GGc0B-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:36711 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754335AbcKIQpd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 11:45:33 -0500
Content-Disposition: inline
In-Reply-To: <CAFd313x-mXpy0N3aKx2rfoag1FNOrN-LzKb5UHkY2L+GGc0B-A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rameshwar Sahu <rsahu@apm.com>
Cc: Olof Johansson <olof@lixom.net>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Devicetree List <devicetree@vger.kernel.org>, linux-arm <linux-arm-kernel@lists.infradead.org>, ddutile@redhat.com, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>

Hello,

On Wed, Sep 14, 2016 at 04:15:00PM +0530, Rameshwar Sahu wrote:
> > @@ -821,8 +823,6 @@ static int xgene_ahci_probe(struct platform_device
> > *pdev)
> >                                 dev_warn(&pdev->dev, "%s: Error reading
> > device info. Assume version1\n",
> >                                         __func__);
> >                                 version = XGENE_AHCI_V1;
> > -                       } else if (info->valid & ACPI_VALID_CID) {
> > -                               version = XGENE_AHCI_V2;

Can you please explain this part a bit?  Everything else looks good to
me.

Thanks.

-- 
tejun
