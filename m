From: Jeffrey Hugo <jhugo@codeaurora.org>
Subject: Re: [PATCH v3 5/5] Revert "scsi: ufs: disable vccq if it's not needed
 by UFS device"
Date: Mon, 4 Feb 2019 13:23:49 -0700
Message-ID: <91e7f06c-7d13-d0bd-efee-4a62a429f727@codeaurora.org>
References: <e3c82a49-c601-effc-348f-f768656c659f@free.fr>
 <70618c25-83f0-b9db-51a3-c1d74b605a45@free.fr>
 <SN6PR04MB49255ADE41BBD35F894FD4CBFC6D0@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN6PR04MB49255ADE41BBD35F894FD4CBFC6D0@SN6PR04MB4925.namprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <Avri.Altman@wdc.com>, Marc Gonzalez <marc.w.gonzalez@free.fr>, MSM <linux-arm-msm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Subhash Jadavani <subhashj@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>, SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2/4/2019 12:51 PM, Avri Altman wrote:
> 
>> This reverts commit 60f0187031c05e04cbadffb62f557d0ff3564490.
>>
>> Calling ufshcd_set_vccq_rail_unused hangs my system.
>> It seems vccq is not *not* needed.
> This patch essentially implements the UFS_DEVICE_NO_VCCQ quirk,
> Which is needed for both Samsung and Hynix devices.

Needed, or optimal?
I'm rather sure Marc's device has a Samsung UFS chip, as do my devices 
and we've seen nothing but benefit from the proposed revert.

> Once acked by those vendors, can be removed from the quirk list as well.
> 
> Thanks,
> Avri
>>
>> Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>


-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
