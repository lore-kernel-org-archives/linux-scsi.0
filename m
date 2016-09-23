From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] devicetree: bindings: scsi: hisi_sas hip07 support
Date: Fri, 23 Sep 2016 13:36:41 -0500
Message-ID: <20160923183641.GA27636@rob-hp-laptop>
References: <1474368540-186535-1-git-send-email-john.garry@huawei.com>
 <1474368540-186535-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474368540-186535-2-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hare-IBi9RG/b67k@public.gmane.org, Xiang Chen <chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 20, 2016 at 06:48:58PM +0800, John Garry wrote:
> Add support for hip07 chipset to bindings.
> 
> Chipset hip07 has v2 hw.
> 
> The sas-v2 quirk amt is expanded to cover hip07.
> 
> Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Xiang Chen <chenxiang66-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> ---
>  Documentation/devicetree/bindings/scsi/hisilicon-sas.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> index bf2411f..e604527 100644
> --- a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> +++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> @@ -6,6 +6,7 @@ Main node required properties:
>    - compatible : value should be as follows:
>  	(a) "hisilicon,hip05-sas-v1" for v1 hw in hip05 chipset
>  	(b) "hisilicon,hip06-sas-v2" for v2 hw in hip06 chipset
> +	(c) "hisilicon,hip07-sas-v2" for v2 hw in hip07 chipset
>    - sas-addr : array of 8 bytes for host SAS address
>    - reg : Address and length of the SAS register
>    - hisilicon,sas-syscon: phandle of syscon used for sas control
> @@ -47,7 +48,7 @@ Main node required properties:
>  			increasing order.
>  
>  Optional main node properties:
> - - hip06-sas-v2-quirk-amt : when set, indicates that the v2 controller has the
> + - hip06/7-sas-v2-quirk-amt : when set, indicates that the v2 controller has the

Just use the existing property name for hip07.

>  			    "am-max-transmissions" limitation.
>  
>  Example:
> -- 
> 1.9.1
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
