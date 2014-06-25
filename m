From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] scsi: pm8001: pm80xx_hwi.c: Cleaning up variable is set
 more than once
Date: Wed, 25 Jun 2014 18:08:16 +0200
Message-ID: <53AAF3F0.3010700@redhat.com>
References: <1403704907-25672-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <53AAEC1A.20905@redhat.com> <CAN7X1Un3-u-Q428-s1dYk5z4P-Bb=jO-N+x1T+PLhH1fDE1MRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAN7X1Un3-u-Q428-s1dYk5z4P-Bb=jO-N+x1T+PLhH1fDE1MRw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Purush Gupta <purush.gupta@nutanix.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, xjtuwjp@gmail.com, lindar_liu@usish.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Linux Kernel List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 06/25/2014 05:41 PM, Purush Gupta wrote:
> Its possible HW may require programming those fields?

I'm looking at the code and it doesn't look so, did you see something suspicious?

> May be original
> contributor of the driver should review...No offense!

I believe it requires the maintainer ACK and it takes precedence in any case, am I wrong?

Regards,
Maurizio Lombardi

> 
> thanks,
> Purush
> 
> 
> On Wed, Jun 25, 2014 at 8:34 AM, Maurizio Lombardi <mlombard@redhat.com>
> wrote:
> 
>> This one looks good to me,
>>
>> Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
>>
>> On 06/25/2014 04:01 PM, Rickard Strandqvist wrote:
>>> A struct member variable is set to different values without having used
>> in between.
>>>
>>> This was found using a static code analysis program called cppcheck
>>>
>>> Signed-off-by: Rickard Strandqvist <
>> rickard_strandqvist@spectrumdigital.se>
>>> ---
>>>  drivers/scsi/pm8001/pm80xx_hwi.c |    1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c
>> b/drivers/scsi/pm8001/pm80xx_hwi.c
>>> index d70587f..2698227 100644
>>> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
>>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>>> @@ -249,7 +249,6 @@ moreData:
>>>                               sprintf(pm8001_ha->
>>>                                       forensic_info.data_buf.direct_data,
>>>                                               "%08x ", 4);
>>> -                     pm8001_ha->forensic_info.data_buf.read_len =
>> 0xFFFFFFFF;
>>>                       pm8001_ha->forensic_info.data_buf.direct_len =  0;
>>>                       pm8001_ha->forensic_info.data_buf.direct_offset =
>> 0;
>>>                       pm8001_ha->forensic_info.data_buf.read_len = 0;
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
