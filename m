From: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 4/7] dt-bindings: phy: Add document for phy-mtk-ufs
Date: Thu, 14 Mar 2019 11:42:40 +0800
Message-ID: <1552534960.30977.58.camel@mtkswgap22>
References: <1551252192-535-1-git-send-email-stanley.chu@mediatek.com>
 <1551252192-535-6-git-send-email-stanley.chu@mediatek.com>
 <1552472519.500.1.camel@mtksdaap41> <1552485918.30977.56.camel@mtkswgap22>
 <CAL_JsqKohcSXw5BcqpQ2eVHf36kVoPdVe+rxJ+6XvdqM4nQ0Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <CAL_JsqKohcSXw5BcqpQ2eVHf36kVoPdVe+rxJ+6XvdqM4nQ0Wg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "mark.rutland-5wv7dgnIgG8@public.gmane.org" <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chun-Hung Wu =?UTF-8?Q?=28=E5=B7=AB=E9=A7=BF=E5=AE=8F=29?= <Chun-hung.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Kuohong Wang =?UTF-8?Q?=28=E7=8E=8B=E5=9C=8B=E9=B4=BB=29?= <kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Peter Wang =?UTF-8?Q?=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29?= <peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "kishon-l0cyMroinI0@public.gmane.org" <kishon-l0cyMroinI0@public.gmane.org>, "avri.altman-Sjgp3cTcYWE@public.gmane.org" <avri.altman-Sjgp3cTcYWE@public.gmane.org>, Chunfeng Yun =?UTF-8?Q?=28=E4=BA=91=E6=98=A5=E5=B3=B0=29?= <Chunfeng.Yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org" <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, "subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Yin
List-Id: linux-scsi@vger.kernel.org

Hi Rob and Yingjoe,

On Thu, 2019-03-14 at 03:52 +0800, Rob Herring wrote:
> On Wed, Mar 13, 2019 at 9:05 AM Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org> wrote:
> >
> > Hi Yingjoe,
> >
> > On Wed, 2019-03-13 at 18:21 +0800, Yingjoe Chen wrote:
> > > On Wed, 2019-02-27 at 15:23 +0800, Stanley Chu wrote:
> > > > Add UFS M-PHY node document for MediaTek SoC chips.
> > > >
> > > > Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > > > ---
> > > >  .../devicetree/bindings/phy/phy-mtk-ufs.txt   | 35 +++++++++++++++++++
> > > >  1 file changed, 35 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt b/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt
> > > > new file mode 100644
> > > > index 000000000000..5fc22c7fe0bc
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt
> > > > @@ -0,0 +1,35 @@
> > > > +MediaTek Universal Flash Storage (UFS) M-PHY binding
> > > > +--------------------------------------------------------
> > > > +
> > > > +UFS M-PHY nodes are defined to describe on-chip UFS M-PHY hardware macro.
> > > > +Each UFS M-PHY node should have its own node.
> > > > +
> > > > +To bind UFS M-PHY with UFS host controller, the controller node should
> > > > +contain a phandle reference to UFS M-PHY node.
> > > > +
> > > > +Required properties for UFS M-PHY nodes:
> > > > +- compatible         : Compatible list, contains the following controller:
> > > > +                       "mediatek,ufs-mphy"
> > > > +- reg                : Address and length of the UFS M-PHY register set.
> > > > +- #phy-cells         : This property shall be set to 0
> > > > +- clocks             : List of phandle and clock specifier pairs.
> > > > +- clock-names        : List of clock input name strings sorted in the same
> > > > +                       order as the clocks property. "unipro-clk" and
> > > > +                       "mp-clk" are mandatory.
> > >
> > > All names in clock-names are clock, don't need to add -clk again.
> > > Please describe shortly what these clock are used.

Will add it.

> > >
> >
> > Sorry this mail is marked as [SPAM] so I did not notice this before
> > sending the same question to Rob.
> >
> > This style seems suitable in phy documents but existed ufs documents
> > already have lots of "_clk" so I am confused.
> >
> > Maybe I need to drop "-clk" in phy documents and use "_clk" in ufs
> > documents?
> >
> > Or wait for Rob's feedback in another mail?
> 
> Generally, -clk or _clk is considered redundant, but maybe you need
> this to be consistent with already defined names?
> 
> Also, there's cases like pclk or aclk and dropping 'clk' on those
> wouldn't make much sense.
> 

Thanks so much for clear explanation.
I will try to fix redundant clock names in next version.

> Rob

Thanks,
Stanley

> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek
