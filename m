From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: ufs-cdns: Add support for UFSHCI with M31 PHY
Date: Wed, 03 Apr 2019 23:24:17 -0400
Message-ID: <yq1mul6tpum.fsf@oracle.com>
References: <20190327144405.5716-1-jank@cadence.com>
        <20190327144405.5716-3-jank@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327144405.5716-3-jank@cadence.com> (Jan Kotas's message of
        "Wed, 27 Mar 2019 14:44:05 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kotas <jank@cadence.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com, martin.petersen@oracle.com, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Jan,

> +	if (hba->vops && hba->vops->phy_initialization) {
> +		status = hba->vops->phy_initialization(hba);
> +		if (status)
> +			return status;
> +	}
> +
> +	return status;

I zapped the superfluous return conditional. Applied patches 1 and 2 to
5.2/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
