From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [REPOST PATCH v4 0/3] scsi: ufs-bsg: Add read descriptor
Date: Wed, 27 Feb 2019 09:00:38 -0500
Message-ID: <yq136o9babd.fsf@oracle.com>
References: <1550646674-15258-1-git-send-email-avri.altman@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550646674-15258-1-git-send-email-avri.altman@wdc.com> (Avri
        Altman's message of "Wed, 20 Feb 2019 09:11:11 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Evan Green <evgreen@chromium.org>, Bean Huo <beanhuo@micron.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Avri,

> UFS Protocol Information Units (UPIU) are UFS packets that travel
> between the host and the device on the UniPro bus. Our previous series
> added the capability to send UPIUs to the ufs driver. It does not
> cover all the possible UPIU types - we are mainly focused on device
> management, provisioning, testing and validation, so it covers UPIUs
> that falls in that box.

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
