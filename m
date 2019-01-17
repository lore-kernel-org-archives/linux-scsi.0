From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 5/8] scsi: ufs: qcom: Expose the reset controller for PHY
Date: Wed, 16 Jan 2019 21:28:07 -0500
Message-ID: <yq1imyoqaq0.fsf@oracle.com>
References: <20190111230129.127037-1-evgreen@chromium.org>
        <20190111230129.127037-6-evgreen@chromium.org>
        <a289d841-858d-5583-ce9a-8dc0f2d18a78@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a289d841-858d-5583-ce9a-8dc0f2d18a78@ti.com> (Kishon Vijay
        Abraham, I's message of "Wed, 16 Jan 2019 14:22:25 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Evan Green <evgreen@chromium.org>, Andy Gross <andy.gross@linaro.org>, Rob Herring <robh+dt@kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Can Guo <cang@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Stephen Boyd <swboyd@chromium.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Kishon,

> On 12/01/19 4:31 AM, Evan Green wrote:
>> Expose a reset controller that the phy can use to perform its
>> initialization in a single callback.
>> 
>> Also, change the use of the phy functions from ufs-qcom such that
>> phy_poweron actually fires up the phy, and phy_poweroff actually
>> powers it down.
>> 
>> Signed-off-by: Evan Green <evgreen@chromium.org>
>
> Can I get Ack for this patch from SCSI MAINTAINERS?

No objection from me if there is general consensus that moving reset to
the phy is the right thing to do.

-- 
Martin K. Petersen	Oracle Linux Engineering
