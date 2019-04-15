From: Wei Xu <xuwei5@hisilicon.com>
Subject: Re: [PATCH v2 2/3] arm64: dts: hisilicon: hi3670: Add UFS controller
 support
Date: Mon, 15 Apr 2019 17:00:20 +0100
Message-ID: <fc511f16-d04f-a376-7173-6d1b26b591b5@hisilicon.com>
References: <20190105072859.9134-1-manivannan.sadhasivam@linaro.org>
 <20190105072859.9134-3-manivannan.sadhasivam@linaro.org>
 <20190220113508.GB7498@ulmo> <yq18syak0c2.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq18syak0c2.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Thierry Reding <thierry.reding@gmail.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, liwei213@huawei.com, robh+dt@kernel.org, devicetree@vger.kernel.org, guodong.xu@linaro.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, amit.kucheria@linaro.org, john.stultz@linaro.org, linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org, xuwei5@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

Hi Manivannan,

On 2/20/2019 2:21 PM, Martin K. Petersen wrote:
> 
> Hi Thierry,
> 
>> it looks like you picked this up into the SCSI tree (perhaps
>> inadvertently). It's been causing linux-next to fail to build since
>> Monday (next-20190218) because it references a phandle (&crg_rst)
>> that's not available.
> 
> I dropped the offending patch from the SCSI tree yesterday. When Stephen
> updates -next, things should be fine.
> 

Thanks!
Applied the dts patch to the hisilicon dts tree.

Best Regards,
Wei
