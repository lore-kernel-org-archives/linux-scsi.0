From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: Re: [PATCH V2] scsi: ufs: Add fDeviceInit set flag during
 initialization
Date: Wed, 8 May 2013 23:38:13 -0700
Message-ID: <6a3ae402d24ff869517c73209b1edb79.squirrel@www.codeaurora.org>
References: <1368022782-27178-1-git-send-email-draviv@codeaurora.org>
    <CALMYJDsYSfDjZ6pug3cZ+wkFaL0VcZnNMk11DFAW7Ay56PjbdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CALMYJDsYSfDjZ6pug3cZ+wkFaL0VcZnNMk11DFAW7Ay56PjbdA@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>> + */
>> +int ufshcd_query_request(struct ufs_hba *hba,
>> +                       struct ufs_query_req *query,
>> +                       u8 *descriptor,
>> +                       struct ufs_query_res *response,
>> +                       int timeout,
>> +                       int retries)
>> +{
>> +       struct scsi_device *sdev;
>> +       u8 cmd[UFS_QUERY_CMD_SIZE] = {0};
>> +       int result;
>> +       bool sdev_lookup = true;
>> +
>> +       if (!hba || !query || !response) {
>> +               dev_err(hba->dev,
>
> Please fix the static checker warnings mentioned by Dan in the previous
> mail.
> Re-base it on Seungwon's V4 patch series and you can add my Acked-by:
> Santosh Y <santoshsy@gmail.com>
>

The fix is ready.
I have to base it on top of Sujit's patch since it is inserted in the flow
he introduced.

>
>
> --
> ~Santosh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Dolev
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
