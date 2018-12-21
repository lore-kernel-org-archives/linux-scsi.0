From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH 1/3] dt-bindings: ufs: Add HI3670 UFS controller binding
Date: Fri, 21 Dec 2018 07:54:44 +0530
Message-ID: <20181221022444.GA3233@Mani-XPS-13-9360>
References: <20181207175151.8969-1-manivannan.sadhasivam@linaro.org>
 <20181207175151.8969-2-manivannan.sadhasivam@linaro.org>
 <20181220171244.GA22403@bogus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181220171244.GA22403@bogus>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, liwei213@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, john.stultz@linaro.org, amit.kucheria@linaro.org, guodong.xu@linaro.org
List-Id: linux-scsi@vger.kernel.org

Hi Rob,

On Thu, Dec 20, 2018 at 11:12:44AM -0600, Rob Herring wrote:
> On Fri, Dec 07, 2018 at 11:21:49PM +0530, Manivannan Sadhasivam wrote:
> > Add devicetree binding for HI3670 UFS controller. HI3760 SoC is very
> > similar to HI3660 SoC with almost same IPs. Only major difference interms
> 
> s/interms/in terms/
> 

Ack.

> > of UFS is the PHY. HI3670 has 10nm PHY.
> > 
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> > index a48c44817367..a327c1e24365 100644
> > --- a/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> > +++ b/Documentation/devicetree/bindings/ufs/ufs-hisi.txt
> > @@ -6,7 +6,9 @@ Each UFS Host Controller should have its own node.
> >  Required properties:
> >  - compatible        : compatible list, contains one of the following -
> >  					"hisilicon,hi3660-ufs", "jedec,ufs-1.1" for hisi ufs
> > -					host controller present on Hi36xx chipset.
> > +					host controller present on Hi3660 chipset.
> > +					"hisilicon,hi3670-ufs", "jedec,ufs-2.1" for hisi ufs
> > +					host controller present on Hi3670 chipset.
> 
> From the description, sounds like having "hisilicon,hi3660-ufs" as a 
> fallback would be appropriate?
> 

I don't think so. As per my understanding, fallback should be only used
when it can make the device functional. But in this case,
"hisilicon,hi3660-ufs" will not make the HI3670 UFS functional. So, I
will stick to "hisilicon,hi3670-ufs" only.

> >  - reg               : should contain UFS register address space & UFS SYS CTRL register address,
> >  - interrupt-parent  : interrupt device
> 
> Don't document interrupt-parent. It is implied.
> 

Ack.

Thanks,
Mani

> >  - interrupts        : interrupt number
> > -- 
> > 2.17.1
> > 
