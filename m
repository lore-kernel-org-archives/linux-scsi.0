From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 1/2] scsi: ufs: Do not disable vccq in UFSHC driver
Date: Tue, 26 Feb 2019 15:00:17 -0500
Message-ID: <yq1lg22b9ri.fsf@oracle.com>
References: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
        <be3ef9bf-438b-4e8a-62c4-f75458e8ecc0@free.fr>
        <yq1ftsad2yi.fsf@oracle.com>
        <b7f37c2d-27c7-9b58-20c8-52624783a6fa@free.fr>
        <yq1bm2yd2kr.fsf@oracle.com>
        <026c10b1-48e8-ab9f-fda8-6e3557b841a7@free.fr>
        <yq1y362bjnw.fsf@oracle.com>
        <8fc2eed2-f94b-8d43-6ca4-86e18f600997@free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8fc2eed2-f94b-8d43-6ca4-86e18f600997@free.fr> (Marc Gonzalez's
        message of "Tue, 26 Feb 2019 18:02:18 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Hannes Reinecke <hare@suse.de>, Kyuho Choi <kyuho.c>
List-Id: linux-scsi@vger.kernel.org


Marc,

> The resolution is simple: we keep the HEAD version, and simply remove
> ufshcd_set_vccq_rail_unused() and its error-handling.
>
>
> Is that the information you were after?

Yes.

> Do you prefer the patch subject to be:
> Revert "scsi: ufs: disable vccq if it's not needed by UFS device"
> instead of:
> scsi: ufs: Do not disable vccq in UFSHC driver
>
> And I should leave in the automatically added
> This reverts commit 60f0187031c05e04cbadffb62f557d0ff3564490.
> while adding some information from the manual resolution?

Exactly.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
