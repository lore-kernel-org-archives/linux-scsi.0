From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v2 3/4] ata: add APM X-Gene SoC 6.0Gbps SATA PHY driver
Date: Wed, 20 Nov 2013 11:16:30 -0800
Message-ID: <CAPw-ZTkrqcmtVP8Y2utzAmL0bsMzQtyxnnuE5+PnYNowvYpvZw@mail.gmail.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
	<1384905197-3566-2-git-send-email-lho@apm.com>
	<1384905197-3566-3-git-send-email-lho@apm.com>
	<1384905197-3566-4-git-send-email-lho@apm.com>
	<CACVXFVPnRCtaFULYf307gfu4jvYpV7cgFOjmq5fOgyfb0Gp+SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:35674 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754609Ab3KTTQb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2013 14:16:31 -0500
Received: by mail-pa0-f50.google.com with SMTP id kp14so8828578pab.9
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 11:16:31 -0800 (PST)
In-Reply-To: <CACVXFVPnRCtaFULYf307gfu4jvYpV7cgFOjmq5fOgyfb0Gp+SA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Jon Masters <jcm@redhat.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tuan Phan <tphan@apm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>

Hi,

I will move to the official GIT for 3.12.00 instead rc7. It is the
same as Linux-next GIT.

-Loc

On Wed, Nov 20, 2013 at 12:57 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Wed, Nov 20, 2013 at 7:53 AM, Loc Ho <lho@apm.com> wrote:
>> +
>> +       sprintf(name, "xgene-ahci-phy-%08X", (u32) ctx->csr_phys);
>> +       ctx->phy = devm_phy_create(ctx->dev, (u32) ctx->csr_phys,
>> +                                  &xgene_phy_ops, name);
>
> The devm_phy_create() API has changed, so suggest you make your
> patch against -next tree.
>
> Thanks,
> --
> Ming Lei
>
> --
> Ming Lei
