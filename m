From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH 4/5] scsi/ufs: qcom: Set phy mode based on the controllers
 HS MODE
Date: Wed, 27 Sep 2017 12:01:16 +0530
Message-ID: <cbe08742-1e12-3cb6-ebcb-590ab6e829df@codeaurora.org>
References: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
 <1501829332-5183-5-git-send-email-vivek.gautam@codeaurora.org>
 <99fc698fc93a05fc227d24a9ae15f183@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <99fc698fc93a05fc227d24a9ae15f183@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: kishon@ti.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org, linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org, devicetree@vger.kernel.org, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com
List-Id: linux-scsi@vger.kernel.org



On 09/27/2017 04:14 AM, Subhash Jadavani wrote:
> On 2017-08-03 23:48, Vivek Gautam wrote:
>> Set the phy mode based on the UFS HS PA mode. This lets the
>> controller let phy know the mode in which the PHY Adapter is
>> running and set the phy rates accordingly.
>>
>> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufs-qcom.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index c87d770b519a..44c21d5818ee 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -273,6 +273,9 @@ static int ufs_qcom_power_up_sequence(struct 
>> ufs_hba *hba)
>>      bool is_rate_B = (UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B)
>>                              ? true : false;
>>
>> +    if (is_rate_B)
>> +        phy_set_mode(phy, PHY_MODE_UFS_HS_B);
>> +
>>      /* Assert PHY reset and apply PHY calibration values */
>>      ufs_qcom_assert_reset(hba);
>>      /* provide 1ms delay to let the reset pulse propagate */
>
> Looks good to me.
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

Thanks for reviewing Subhash.

BRs
Vivek

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
