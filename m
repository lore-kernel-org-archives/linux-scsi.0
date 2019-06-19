From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/1] scsi: ufs-qcom: Add support for platforms booting
 ACPI
Date: Wed, 19 Jun 2019 06:42:22 +0100
Message-ID: <20190619054222.GE18371@dell>
References: <20190617115454.3226-1-lee.jones@linaro.org>
 <yq1zhmeuvst.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1zhmeuvst.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: agross@kernel.org, david.brown@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, jlhugo@gmail.com, bjorn.andersson@linaro.org
List-Id: linux-scsi@vger.kernel.org

Ard, Martin,

On Tue, 18 Jun 2019, Martin K. Petersen wrote:
> > New Qualcomm AArch64 based laptops are now available which use UFS
> > as their primary data storage medium.  These devices are supplied
> > with ACPI support out of the box.  This patch ensures the Qualcomm
> > UFS driver will be bound when the "QCOM24A5" H/W device is
> > advertised as present.
> 
> Applied to 5.3/scsi-queue. Thanks!

Ideal.  Thanks for your help.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
