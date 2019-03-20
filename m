From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v3 0/8] phy: qcom-ufs: Enable regulators to be off in
 suspend
Date: Wed, 20 Mar 2019 14:36:00 +0530
Message-ID: <405b80c6-2624-cc7d-24fa-670b7e8cb3a9@ti.com>
References: <20190205185902.106085-1-evgreen@chromium.org>
 <CAE=gft4YPmqd35ySmZw2UG876Lvt8rcz+nNwELXK98PDvHuVeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft4YPmqd35ySmZw2UG876Lvt8rcz+nNwELXK98PDvHuVeA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>, Andy Gross <andy.gross@linaro.org>
Cc: Stephen Boyd <swboyd@chromium.org>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Grygorii Strashko <grygorii.strashko@ti.com>, Rob Herring <robh+dt@kernel.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Jeffrey Hugo <jhugo@codeaurora.org>, SCSI <linux-scsi@vger.kernel.org>, David Brown <david.brown@linaro.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, liwei <liwei213@huawei.com>, linux-arm-msm <linux-arm-msm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Evan,

On 20/03/19 1:34 AM, Evan Green wrote:
> On Tue, Feb 5, 2019 at 10:59 AM Evan Green <evgreen@chromium.org> wrote:
>>
> ...
>> Evan Green (8):
>>   dt-bindings: ufs: Add #reset-cells for Qualcomm controllers
>>   dt-bindings: phy-qcom-qmp: Add UFS PHY reset
>>   dt-bindings: phy: qcom-ufs: Add resets property
>>   arm64: dts: sdm845: Add UFS PHY reset
>>   arm64: dts: msm8996: Add UFS PHY reset controller
>>   scsi: ufs: qcom: Expose the reset controller for PHY
>>   phy: qcom: Utilize UFS reset controller
>>   phy: ufs-qcom: Refactor all init steps into phy_poweron
>>
>>  .../devicetree/bindings/phy/qcom-qmp-phy.txt  |   6 +-
>>  .../devicetree/bindings/ufs/ufs-qcom.txt      |   5 +-
>>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt |   3 +
>>  arch/arm64/boot/dts/qcom/msm8996.dtsi         |   4 +-
>>  arch/arm64/boot/dts/qcom/sdm845.dtsi          |   3 +
>>  drivers/phy/qualcomm/phy-qcom-qmp.c           | 117 +++++++++---------
>>  drivers/phy/qualcomm/phy-qcom-ufs-i.h         |   5 +-
>>  drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c  |  25 +---
>>  drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c  |  25 +---
>>  drivers/phy/qualcomm/phy-qcom-ufs.c           |  57 +++++++--
>>  drivers/scsi/ufs/Kconfig                      |   1 +
>>  drivers/scsi/ufs/ufs-qcom.c                   | 114 ++++++++++-------
>>  drivers/scsi/ufs/ufs-qcom.h                   |   4 +
>>  13 files changed, 202 insertions(+), 167 deletions(-)
>>
>> --
> 
> Hi Kishon,
> A gentle ping here now that rc1 is out. Are you able to take these? I
> can also repost if needed.

Can you repost with the updated tags please?

Thanks
Kishon
