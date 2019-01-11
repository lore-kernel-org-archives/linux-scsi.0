From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/3] dt-bindings: ufs: Add HI3670 UFS controller
 binding
Date: Fri, 11 Jan 2019 15:35:02 -0600
Message-ID: <20190111213502.GA24538@bogus>
References: <20190105072859.9134-1-manivannan.sadhasivam@linaro.org>
 <20190105072859.9134-2-manivannan.sadhasivam@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190105072859.9134-2-manivannan.sadhasivam@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, liwei213@huawei.com, robh+dt@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, john.stultz@linaro.org, amit.kucheria@linaro.org, guodong.xu@linaro.org, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
List-Id: linux-scsi@vger.kernel.org

On Sat,  5 Jan 2019 12:58:57 +0530, Manivannan Sadhasivam wrote:
> Add devicetree binding for HI3670 UFS controller. HI3760 SoC is very
> similar to HI3660 SoC with almost same IPs. Only major difference in terms
> of UFS is the PHY. HI3670 has 10nm PHY. But since the original driver
> (HI3660 UFS) cannot make HI3670 UFS functional, a separate compatible
> is added for HI3670 without any fallback.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
