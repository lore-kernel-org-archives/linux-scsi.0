From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH v2 1/3] dt-bindings: ufs: Add HI3670 UFS controller binding
Date: Sat, 16 Feb 2019 09:38:55 +0530
Message-ID: <20190216040855.GA3054@Mani-XPS-13-9360>
References: <20190105072859.9134-1-manivannan.sadhasivam@linaro.org>
 <20190105072859.9134-2-manivannan.sadhasivam@linaro.org>
 <20190111213502.GA24538@bogus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190111213502.GA24538@bogus>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
Cc: Rob Herring <robh@kernel.org>, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, devicetree@vger.kernel.org, guodong.xu@linaro.org, linux-kernel@vger.kernel.org, amit.kucheria@linaro.org, robh+dt@kernel.org, john.stultz@linaro.org, liwei213@huawei.com, vinholikatti@gmail.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 11, 2019 at 03:35:02PM -0600, Rob Herring wrote:
> On Sat,  5 Jan 2019 12:58:57 +0530, Manivannan Sadhasivam wrote:
> > Add devicetree binding for HI3670 UFS controller. HI3760 SoC is very
> > similar to HI3660 SoC with almost same IPs. Only major difference in terms
> > of UFS is the PHY. HI3670 has 10nm PHY. But since the original driver
> > (HI3660 UFS) cannot make HI3670 UFS functional, a separate compatible
> > is added for HI3670 without any fallback.
> > 
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/ufs/ufs-hisi.txt | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> 
> Reviewed-by: Rob Herring <robh@kernel.org>

Martin,

Can you please take the bindings patch also? DT patch will go through
HiSi tree.

Thanks,
Mani
