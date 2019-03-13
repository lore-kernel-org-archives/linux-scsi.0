From: Yingjoe Chen <yingjoe.chen-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [SPAM][PATCH v3 4/7] dt-bindings: phy: Add document for
 phy-mtk-ufs
Date: Wed, 13 Mar 2019 18:21:59 +0800
Message-ID: <1552472519.500.1.camel@mtksdaap41>
References: <1551252192-535-1-git-send-email-stanley.chu@mediatek.com>
 <1551252192-535-6-git-send-email-stanley.chu@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mediatek-bounces+glpam-linux-mediatek=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1551252192-535-6-git-send-email-stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
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
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, chun-hung.wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kuohong.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, kishon-l0cyMroinI0@public.gmane.org, avri.altman-Sjgp3cTcYWE@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, chunfeng.yun-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, pedrom.sousa-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, peter.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-02-27 at 15:23 +0800, Stanley Chu wrote:
> Add UFS M-PHY node document for MediaTek SoC chips.
> 
> Signed-off-by: Stanley Chu <stanley.chu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> ---
>  .../devicetree/bindings/phy/phy-mtk-ufs.txt   | 35 +++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt
> 
> diff --git a/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt b/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt
> new file mode 100644
> index 000000000000..5fc22c7fe0bc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/phy-mtk-ufs.txt
> @@ -0,0 +1,35 @@
> +MediaTek Universal Flash Storage (UFS) M-PHY binding
> +--------------------------------------------------------
> +
> +UFS M-PHY nodes are defined to describe on-chip UFS M-PHY hardware macro.
> +Each UFS M-PHY node should have its own node.
> +
> +To bind UFS M-PHY with UFS host controller, the controller node should
> +contain a phandle reference to UFS M-PHY node.
> +
> +Required properties for UFS M-PHY nodes:
> +- compatible         : Compatible list, contains the following controller:
> +                       "mediatek,ufs-mphy"
> +- reg                : Address and length of the UFS M-PHY register set.
> +- #phy-cells         : This property shall be set to 0
> +- clocks             : List of phandle and clock specifier pairs.
> +- clock-names        : List of clock input name strings sorted in the same
> +                       order as the clocks property. "unipro-clk" and
> +                       "mp-clk" are mandatory.

All names in clock-names are clock, don't need to add -clk again.
Please describe shortly what these clock are used.

Joe.C
