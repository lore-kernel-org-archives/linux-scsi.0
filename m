From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 09/23] hisi_sas: add v2 hw init
Date: Fri, 8 Jan 2016 15:07:50 +0000
Message-ID: <20160108150750.GI3097@leverpostej>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
 <1452262542-64589-10-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452262542-64589-10-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 08, 2016 at 10:15:28PM +0800, John Garry wrote:

> +	/* Global registers init*/
> +	if (of_get_property(np, "am-max-trans", NULL)) {
> +		hisi_sas_write32(hisi_hba, AM_CFG_MAX_TRANS, 0x2020);
> +		hisi_sas_write32(hisi_hba, AM_CFG_SINGLE_PORT_MAX_TRANS,
> +				 0x2020);
> +	}

Use of_property_read_bool for boolean properties like this.

I still don't follow exactly what this property means, and why it is
necessary, but that's an issue for the binding document.

Thanks,
Mark.
