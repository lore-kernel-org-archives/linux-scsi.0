From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Remove select of phy-qcom-ufs from ufs-qcom
Date: Fri, 11 Jan 2019 22:37:19 -0500
Message-ID: <yq1imyuv95c.fsf@oracle.com>
References: <20190111233159.218342-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190111233159.218342-1-evgreen@chromium.org> (Evan Green's
        message of "Fri, 11 Jan 2019 15:31:59 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Douglas Anderson <dianders@chromium.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Evan,

> CONFIG_SCSI_UFS_QCOM selects CONFIG_PHY_QCOM_UFS, assuming that
> this was the only possible PHY driver Qualcomm's UFS controller
> would use. But in SDM845, the UFS driver is bundled into phy-qcom-qmp,
> and phy-qcom-ufs is unused.
>
> Remove the select, since for SDM845 it adds useless drivers to the
> build.

Applied to 5.1/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
