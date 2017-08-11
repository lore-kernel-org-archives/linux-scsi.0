From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/5] qcom-ufs: phy/hcd: Refactor phy initialization code
Date: Thu, 10 Aug 2017 20:03:27 -0400
Message-ID: <yq1y3qr2cog.fsf@oracle.com>
References: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
        <c29e3a7c-62cc-f25a-4e0b-231c69e01afa@ti.com>
        <b69ecef93852cf5a7bf342550de16f19@codeaurora.org>
        <d49316e0-8ccc-21b3-e952-ddb0a941f3b3@ti.com>
        <CAFp+6iF7m5vgGZcrOTXcxtPinVYUn0iPq1vAjXT909zfHu+wVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFp+6iF7m5vgGZcrOTXcxtPinVYUn0iPq1vAjXT909zfHu+wVQ@mail.gmail.com>
        (Vivek Gautam's message of "Wed, 9 Aug 2017 12:14:44 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Subhash Jadavani <subhashj@codeaurora.org>, Kishon Vijay Abraham I <kishon@ti.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, robh+dt <robh+dt@kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, jejb@linux.vnet.ibm.com, Vinayak Holikatti <vinholikatti@gmail.com>, linux-arm-msm-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Vivek,

> Can you kindly review this patch series (for UFS controller changes)
> and consider giving your Ack so that Kishon can pull in the series
> through phy tree.

SCSI piece looks OK.

Would still like Subhash to review the rest.

-- 
Martin K. Petersen	Oracle Linux Engineering
