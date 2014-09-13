From: Sergei Shtylyov <sergei.shtylyov-M4DtvfQ/ZS1MRgGoP+s0PdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH fix for 3.17 v2] uas: Add a quirk for rejecting ATA_12
 and ATA_16 commands
Date: Sat, 13 Sep 2014 23:27:48 +0300
Message-ID: <5414A8C4.5090104@cogentembedded.com>
References: <1410631347-8406-1-git-send-email-hdegoede@redhat.com> <5414992B.8020309@mageia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5414992B.8020309-odJJhXpcy38dnm+yROfE0A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Backlund <tmb-odJJhXpcy38dnm+yROfE0A@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 9/13/2014 10:21 PM, Thomas Backlund wrote:

>> And set this quirk for the Seagate Expansion Desk (0bc2:2312), as that one
>> seems to hang upon receiving an ATA_12 or ATA_16 command.

>> https://bugzilla.kernel.org/show_bug.cgi?id=79511

>> While at it also add missing documentation for the u value for usb-storage
>> quirks.

>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.16
>> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

>> --
>> Changes in v2: Add documentation for new t and u usb-storage.quirks flags
>> ---
>>   Documentation/kernel-parameters.txt |  3 +++
>>   drivers/usb/storage/uas.c           | 13 +++++++++++++
>>   drivers/usb/storage/unusual_uas.h   | 16 ++++++----------
>>   drivers/usb/storage/usb.c           |  6 +++++-
>>   include/linux/usb_usual.h           |  2 ++
>>   5 files changed, 29 insertions(+), 11 deletions(-)

>> diff --git a/Documentation/kernel-parameters.txt
>> b/Documentation/kernel-parameters.txt
>> index 5ae8608..7c32053 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -3541,6 +3541,9 @@ bytes respectively. Such letter suffixes can also be
>> entirely omitted.
>>                       bogus residue values);
>>                   s = SINGLE_LUN (the device has only one
>>                       Logical Unit);
>> +                t = NO_ATA_1X (don't allow ATA12 and ATA12
>> +                    commands, uas only);

> I guess you meant ATA12 and *ATA16*

    ... or even ATA(12) and ATA(16). As far as I remember SCSI, it has CDB 
length in parens for the command names.

WBR, Sergei

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
