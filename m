From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/3] dt-bindings: ufs: Add HI3670 UFS controller binding
Date: Thu, 20 Dec 2018 11:12:44 -0600
Message-ID: <20181220171244.GA22403@bogus>
References: <20181207175151.8969-1-manivannan.sadhasivam@linaro.org>
 <20181207175151.8969-2-manivannan.sadhasivam@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181207175151.8969-2-manivannan.sadhasivam@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, liwei213@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, john.stultz@linaro.org, amit.kucheria@linaro.org, guodong.xu@linaro.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 07, 2018 at 11:21:49PM +0530, Manivannan Sadhasivam wrote:
> Add devicetree binding for HI3670 UFS controller. HI3760 SoC is very
> similar to HI3660 SoC with almost same IPs. Only major difference interms

s/interms/in terms/

> of UFS is the PHY. HI3670 has 10nm PHY.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> index a48c44817367..a327c1e24365 100644
> --- a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> +++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> @@ -6,7 +6,9 @@ Each UFS Host Controller should have its own node.
>  Required properties:
>  - compatible        : compatible list, contains one of the following -
>  					"hisilicon,hi3660-ufs", "jedec,ufs-1.1" for hisi ufs
> -					host controller present on Hi36xx chipset.
> +					host controller present on Hi3660 chipset.
> +					"hisilicon,hi3670-ufs", "jedec,ufs-2.1" for hisi ufs
> +					host controller present on Hi3670 chipset.

>From the description, sounds like having "hisilicon,hi3660-ufs" as a 
fallback would be appropriate?

>  - reg               : should contain UFS register address space & UFS SYS CTRL register address,
>  - interrupt-parent  : interrupt device

Don't document interrupt-parent. It is implied.

>  - interrupts        : interrupt number
> -- 
> 2.17.1
> 
