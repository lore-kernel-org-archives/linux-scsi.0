From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 6/7] phy: mediatek: Add UFS M-PHY driver
Date: Wed, 13 Mar 2019 18:17:40 +0800
Message-ID: <1552472260.30977.41.camel@mtkswgap22>
References: <1551252192-535-1-git-send-email-stanley.chu@mediatek.com>
 <1551252192-535-8-git-send-email-stanley.chu@mediatek.com>
 <1552469851.25686.3.camel@mtksdaap41>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1552469851.25686.3.camel@mtksdaap41>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Yingjoe Chen <yingjoe.chen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: "mark.rutland-5wv7dgnIgG8@public.gmane.org" <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= <Chun-hung.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= <kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "kishon-l0cyMroinI0@public.gmane.org" <kishon-l0cyMroinI0@public.gmane.org>, "avri.altman-Sjgp3cTcYWE@public.gmane.org" <avri.altman-Sjgp3cTcYWE@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org" <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Chunfeng Yun =?UTF-8?Q?=28=E4=BA=91=E6=98=A5=E5=B3=B0=29?= <Chunfeng.Yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, linux-mediatek-IAPFreCvJWM7uuMidbF8XQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi, Yingjoe,

On Wed, 2019-03-13 at 17:37 +0800, Yingjoe Chen wrote:
> On Wed, 2019-02-27 at 15:23 +0800, Stanley Chu wrote:
> > Add UFS M-PHY driver on MediaTek chipsets.
> > 
> > Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/phy/mediatek/Kconfig       |   9 ++
> >  drivers/phy/mediatek/Makefile      |   1 +
> >  drivers/phy/mediatek/phy-mtk-ufs.c | 239 +++++++++++++++++++++++++++++
> >  3 files changed, 249 insertions(+)
> >  create mode 100644 drivers/phy/mediatek/phy-mtk-ufs.c
> > 
> > diff --git a/drivers/phy/mediatek/Kconfig b/drivers/phy/mediatek/Kconfig
> > index 8857d00b3c65..4a20110a511d 100644
> > --- a/drivers/phy/mediatek/Kconfig
> > +++ b/drivers/phy/mediatek/Kconfig
> > @@ -21,3 +21,12 @@ config PHY_MTK_XSPHY
> >  	  Enable this to support the SuperSpeedPlus XS-PHY transceiver for
> >  	  USB3.1 GEN2 controllers on MediaTek chips. The driver supports
> >  	  multiple USB2.0, USB3.1 GEN2 ports.
> > +
> > +config PHY_MTK_UFS
> > +	tristate "MediaTek UFS M-PHY driver"
> 
> Please sorting according to config name.

Will fix it.

> 
> > +	depends on ARCH_MEDIATEK && OF
> > +	select GENERIC_PHY
> > +	help
> > +	  Support for UFS M-PHY on MediaTek chipsets. Enable this to provide
> > +	  vendor-specific initialization, power on and off flow of specified
> > +	  M-PHYs.
> > diff --git a/drivers/phy/mediatek/Makefile b/drivers/phy/mediatek/Makefile
> > index ee49edc97ee9..14e9aa0b8aa4 100644
> > --- a/drivers/phy/mediatek/Makefile
> > +++ b/drivers/phy/mediatek/Makefile
> > @@ -5,3 +5,4 @@
> >  
> >  obj-$(CONFIG_PHY_MTK_TPHY)		+= phy-mtk-tphy.o
> >  obj-$(CONFIG_PHY_MTK_XSPHY)		+= phy-mtk-xsphy.o
> > +obj-$(CONFIG_PHY_MTK_UFS)		+= phy-mtk-ufs.o
> 
> Same here.

Will fix it.

> 
> > diff --git a/drivers/phy/mediatek/phy-mtk-ufs.c b/drivers/phy/mediatek/phy-mtk-ufs.c
> > new file mode 100644
> > index 000000000000..7375ad83af05
> > --- /dev/null
> > +++ b/drivers/phy/mediatek/phy-mtk-ufs.c
> > @@ -0,0 +1,239 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2019 MediaTek Inc.
> > + * Author: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/delay.h>
> > +#include <linux/io.h>
> > +#include <linux/module.h>
> > +#include <linux/phy/phy.h>
> > +#include <linux/platform_device.h>
> > +
> > +/* mphy register and offsets */
> > +#define MP_GLB_DIG_8C               0x008C
> > +#define FRC_PLL_ISO_EN              BIT(8)
> > +#define PLL_ISO_EN                  BIT(9)
> > +#define FRC_FRC_PWR_ON              BIT(10)
> > +#define PLL_PWR_ON                  BIT(11)
> > +
> > +#define MP_LN_DIG_RX_9C             0xA09C
> > +#define FSM_DIFZ_FRC                BIT(18)
> > +
> > +#define MP_LN_DIG_RX_AC             0xA0AC
> > +#define FRC_RX_SQ_EN                BIT(0)
> > +#define RX_SQ_EN                    BIT(1)
> > +
> > +#define MP_LN_RX_44                 0xB044
> > +#define FRC_CDR_PWR_ON              BIT(17)
> > +#define CDR_PWR_ON                  BIT(18)
> > +#define FRC_CDR_ISO_EN              BIT(19)
> > +#define CDR_ISO_EN                  BIT(20)
> > +
> > +#define mphy_readl(phy, ofs) readl((phy)->mmio + (ofs))
> > +#define mphy_writel(phy, val, ofs) writel((val), (phy)->mmio + (ofs))
> > +
> > +struct ufs_mtk_phy {
> > +	struct device *dev;
> > +	void __iomem *mmio;
> > +	struct clk *mp_clk;
> > +	struct clk *unipro_clk;
> > +};
> > +
> > +static inline void mphy_set_bit(struct ufs_mtk_phy *phy, u32 reg, u32 ofs)
> 
> Don't need to add inline, let compiler decide this.

Will fix it.

> 
> > +{
> > +	u32 val;
> > +
> > +	val = mphy_readl(phy, reg);
> > +	val |= ofs;
> 
> Value in ofs is bit value, not offset. Maybe need a better name.

Will fix it.

> 
> Joe.C
> 
> 

Thanks for review,
Stanley.
