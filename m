From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] dt-bindings: ufs: Fix the compatible string definition
Date: Fri, 08 Feb 2019 17:40:37 -0500
Message-ID: <yq1lg2px5sq.fsf@oracle.com>
References: <20181012213926.253765-1-dianders@chromium.org>
        <1ca83453-89e1-82c1-2720-987407bd9fa8@free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1ca83453-89e1-82c1-2720-987407bd9fa8@free.fr> (Marc Gonzalez's
        message of "Wed, 6 Feb 2019 14:59:41 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Douglas Anderson <dianders@chromium.org>, Evan Green <evgreen@chromium.org>, Rob Herring <robh+dt@kernel.org>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org


Marc,

>> - compatible: must contain "jedec,ufs-1.1" or "jedec,ufs-2.0", may
>>               also list one or more of the following:
>>                  "qcom,msm8994-ufshc"
>>                  "qcom,msm8996-ufshc"
>>                  "qcom,ufshc"

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
