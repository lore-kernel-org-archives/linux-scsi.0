From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 5/7] dt-bindings: scsi: ufs: Add document for
 ufs-mediatek
Date: Wed, 13 Mar 2019 14:48:31 -0500
Message-ID: <CAL_JsqJ8EkM5EsQCCsyY0M1SuDar2qQi6QjA=91+Svv79-8rAg@mail.gmail.com>
References: <1551252192-535-1-git-send-email-stanley.chu@mediatek.com>
 <1551252192-535-7-git-send-email-stanley.chu@mediatek.com>
 <20190312133113.GA8956@bogus> <1552444909.30977.39.camel@mtkswgap22>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1552444909.30977.39.camel@mtkswgap22>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mediatek/>
List-Post: <mailto:linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mediatek>,
 <mailto:linux-mediatek-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "Linux-mediatek" <linux-mediatek-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Cc: "mark.rutland-5wv7dgnIgG8@public.gmane.org" <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, =?UTF-8?B?S3VvaG9uZyBXYW5nICjnjovlnIvptLsp?= <kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "kishon-l0cyMroinI0@public.gmane.org" <kishon-l0cyMroinI0@public.gmane.org>, "avri.altman-Sjgp3cTcYWE@public.gmane.org" <avri.altman-Sjgp3cTcYWE@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org" <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, =?UTF-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= <Chunfeng.Yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org" <pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>vi
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 12, 2019 at 9:41 PM Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org> wrote:
>
> Hi Rob,
>
> On Tue, 2019-03-12 at 21:31 +0800, Rob Herring wrote:
> > On Wed, Feb 27, 2019 at 03:23:10PM +0800, Stanley Chu wrote:
> > > Add UFS and UFS PHY node document for Mediatek SoC chips.
> > >
> > > Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > > ---
> > >  .../devicetree/bindings/ufs/ufs-mediatek.txt  | 47 +++++++++++++++++++
> > >  1 file changed, 47 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-mediatek.txt
> > >
> > > diff --git a/Documentation/devicetree/bindings/ufs/ufs-mediatek.txt b/Documentation/devicetree/bindings/ufs/ufs-mediatek.txt
> > > new file mode 100644
> > > index 000000000000..5fc985928b3e
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/ufs/ufs-mediatek.txt
> > > @@ -0,0 +1,47 @@
> > > +* Mediatek Universal Flash Storage (UFS) Host Controller
> > > +
> > > +UFS nodes are defined to describe on-chip UFS hardware macro.
> > > +Each UFS Host Controller should have its own node.
> > > +
> > > +To bind UFS PHY with UFS host controller, the controller node should
> > > +contain a phandle reference to UFS M-PHY node.
> > > +
> > > +Required properties for UFS nodes:
> > > +- compatible         : Compatible list, contains the following controller:
> > > +                       "mediatek,ufshci"
> >
> > Needs an SoC specific compatible string.
>
> Will add.
>
> >
> > > +- reg                : Address and length of the UFS register set.
> > > +- interrupt-parent   : Interrupt device.
> >
> > Drop this. It is implied or may be in a parent node.
>
> Will remove it.
>
> >
> > > +- phys               : phandle to m-phy.
> > > +- clocks             : List of phandle and clock specifier pairs.
> > > +- clock-names        : List of clock input name strings sorted in the same
> > > +                       order as the clocks property. "ufs-clk" is mandatory.
> > > +- freq-table-hz      : Array of <min max> operating frequencies stored in the same
> > > +                       order as the clocks property. If this property is not
> > > +                       defined or a value in the array is "0" then it is assumed
> > > +                       that the frequency is set by the parent clock or a
> > > +                       fixed rate clock source.
> > > +- vcc-supply         : Power to the UFS device.
> > > +- vcc-fixed-regulator: Specify that vcc-supply is a fixed regulator.
> >
> > Why is this needed? The driver could query the voltage range of the
> > regulator or you could check the regulator node.
>
> Both ufshcd-pltfrm.txt and ufshcd-pltfrm.c driver allow
>
> - <name>-fixed-regulator : boolean property specifying that
> <name>-supply is a fixed regulator.
>
> Our vcc does not require further initializatio, so is it OK here or
> shall we also modify both ufshcd-pltfrm dt-bindings document and ufs
> driver to avoid using it ?

There are no users of that property in tree and doesn't look like
adding it was ever reviewed. We have standard ways to handle this and
don't need a custom property.

Rob
