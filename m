From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/3] arm64: dts: hisilicon: hi3670: Add UFS controller support
Date: Wed, 20 Feb 2019 09:21:01 -0500
Message-ID: <yq18syak0c2.fsf@oracle.com>
References: <20190105072859.9134-1-manivannan.sadhasivam@linaro.org>
        <20190105072859.9134-3-manivannan.sadhasivam@linaro.org>
        <20190220113508.GB7498@ulmo>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190220113508.GB7498@ulmo> (Thierry Reding's message of "Wed,
        20 Feb 2019 12:35:08 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Thierry Reding <thierry.reding@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, liwei213@huawei.com, robh+dt@kernel.org, devicetree@vger.kernel.org, guodong.xu@linaro.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, amit.kucheria@linaro.org, john.stultz@linaro.org, linux-arm-kernel@lists.infradead.org, Wei Xu <xuwei5@hisilicon.com>, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi Thierry,

> it looks like you picked this up into the SCSI tree (perhaps
> inadvertently). It's been causing linux-next to fail to build since
> Monday (next-20190218) because it references a phandle (&crg_rst)
> that's not available.

I dropped the offending patch from the SCSI tree yesterday. When Stephen
updates -next, things should be fine.

-- 
Martin K. Petersen	Oracle Linux Engineering
