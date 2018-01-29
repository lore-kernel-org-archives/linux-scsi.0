From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] devicetree: bindings: scsi: hisi_sas: add LED
 feature for v2 hw
Date: Mon, 29 Jan 2018 11:27:49 -0600
Message-ID: <20180129172749.yvwiulwxebvvrcja@rob-hp-laptop>
References: <1516207614-159721-1-git-send-email-john.garry@huawei.com>
 <1516207614-159721-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516207614-159721-2-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Xiaofei Tan <tanxiaofei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 18, 2018 at 12:46:52AM +0800, John Garry wrote:
> From: Xiaofei Tan <tanxiaofei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

"dt-bindings: ..." is the preferred subject prefix.

> 
> Add directly attached disk LED feature for v2 hw.
> 
> Signed-off-by: Xiaofei Tan <tanxiaofei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  Documentation/devicetree/bindings/scsi/hisilicon-sas.txt | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> index b6a869f..df3bef7 100644
> --- a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> +++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
> @@ -8,7 +8,10 @@ Main node required properties:
>  	(b) "hisilicon,hip06-sas-v2" for v2 hw in hip06 chipset
>  	(c) "hisilicon,hip07-sas-v2" for v2 hw in hip07 chipset
>    - sas-addr : array of 8 bytes for host SAS address
> -  - reg : Address and length of the SAS register
> +  - reg : Contains two regions. The first is the address and length of the SAS
> +          register. The second is the address and length of CPLD register for
> +          SGPIO control. The second is optional, and should be set only when
> +          we use a CPLD for directly attached disk LED control.

Ah SGPIO, what nice memories I have of trying to support that after the 
chip was done. Seems you have the same fortune. :)

What happens if you have a different CPLD or SGPIO control? Really this 
should probably be a separate node, but the kernel isn't setup for 
separate SGPIO drivers either. 

Reviewed-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
