From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: ufs-qcom: Add support for platforms booting ACPI
Date: Tue, 18 Jun 2019 22:57:06 -0400
Message-ID: <yq1zhmeuvst.fsf@oracle.com>
References: <20190617115454.3226-1-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190617115454.3226-1-lee.jones@linaro.org> (Lee Jones's message
 of "Mon, 17 Jun 2019 12:54:54 +0100")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, avri.altman@wdc.com, linux-arm-msm@vger.kernel.org, jejb@linux.ibm.com, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org, david.brown@linaro.org, agross@kernel.org, alim.akhtar@samsung.com, jlhugo@gmail.com, pedrom.sousa@synopsys.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org


Lee,

> New Qualcomm AArch64 based laptops are now available which use UFS
> as their primary data storage medium.  These devices are supplied
> with ACPI support out of the box.  This patch ensures the Qualcomm
> UFS driver will be bound when the "QCOM24A5" H/W device is
> advertised as present.

Applied to 5.3/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
