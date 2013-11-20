From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2 3/4] ata: add APM X-Gene SoC 6.0Gbps SATA PHY driver
Date: Wed, 20 Nov 2013 16:57:33 +0800
Message-ID: <CACVXFVPnRCtaFULYf307gfu4jvYpV7cgFOjmq5fOgyfb0Gp+SA@mail.gmail.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
	<1384905197-3566-2-git-send-email-lho@apm.com>
	<1384905197-3566-3-git-send-email-lho@apm.com>
	<1384905197-3566-4-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1384905197-3566-4-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, jcm@redhat.com, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tuan Phan <tphan@apm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 20, 2013 at 7:53 AM, Loc Ho <lho@apm.com> wrote:
> +
> +       sprintf(name, "xgene-ahci-phy-%08X", (u32) ctx->csr_phys);
> +       ctx->phy = devm_phy_create(ctx->dev, (u32) ctx->csr_phys,
> +                                  &xgene_phy_ops, name);

The devm_phy_create() API has changed, so suggest you make your
patch against -next tree.

Thanks,
--
Ming Lei

-- 
Ming Lei
