From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v2 1/9] snic: snic module infrastructure
Date: Thu, 12 Mar 2015 01:56:37 +0000
Message-ID: <D126F018.1B707%nmusini@cisco.com>
References: <1426093299-4511-1-git-send-email-nmusini@cisco.com>
 <1426093299-4511-2-git-send-email-nmusini@cisco.com>
 <CAGRGNgWQ2TndGCgpkBrGveKPDpnExMdZc86ysE_2CLgiTMSUeQ@mail.gmail.com>
 <C243A617-47A8-4568-A8ED-2E343812ADA9@cisco.com>
 <CAGRGNgUbUmru+X8chhtwFZCsZQ-FKES2-ZcJz_D62X+tsOhgEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-2.cisco.com ([173.37.142.89]:57808 "EHLO
	alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbbCLB4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2015 21:56:39 -0400
In-Reply-To: <CAGRGNgUbUmru+X8chhtwFZCsZQ-FKES2-ZcJz_D62X+tsOhgEQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <13C288942E6ACC4BA82E4A1FFC2B28D1@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Julian Calby,

  Sure, thanks.

Thanks
Narsimhulu

On 12/03/15 7:13 am, "Julian Calaby" <julian.calaby@gmail.com> wrote:

>Hi simha,
>
>On Thu, Mar 12, 2015 at 12:37 PM, Narsimhulu Musini (nmusini)
><nmusini@cisco.com> wrote:
>> Hi,
>>
>>   Thanks for pointing the change log location. Do you suggest to
>>resubmit the entire patch series with v2. If you find some time, Could
>>you please review the patch.
>
>Firstly, please don't top post (i.e. post above the reply) and please
>don't take discussions off list. (always reply-to-all)
>
>I can almost guarantee that you'll get more comments, so wait for
>other people to review it first.
>
>I don't know the SCSI code well enough to do a useful technical
>review, so I only review for basic style issues.
>
>Thanks,
>
>Julian Calaby
>
>
>> Thanks
>> simha
>>
>>
>> On 12-Mar-2015, at 6:24 am, Julian Calaby <julian.calaby@gmail.com>
>>wrote:
>>
>>> Hi,
>>>
>>> On Thu, Mar 12, 2015 at 4:01 AM, Narsimhulu Musini <nmusini@cisco.com>
>>>wrote:
>>>> snic_main.c contains module load and unload, global driver context,
>>>> PCI Registration, PCI probe and remove, SCSI ML registration
>>>>functionality.
>>>>
>>>> snic.h contains snic structure definition, snic global context, and
>>>> prototypes.
>>>>
>>>> snic_os.h contains OS specific interfaces.
>>>>
>>>> snic_attrs.c contains device attributes to list snic state, link
>>>>state,
>>>> and driver version under /sys/class/scsi_host/host<id>/
>>>>
>>>> v2
>>>> Added Compile time macro for debugfs dependent functionality.
>>>
>>> Your changelog should be below the "---" and before the diffstat.
>>>
>>>> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
>>>> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
>>>> ---
>>>
>>> I.e. here.
>>>
>>>> drivers/scsi/snic/snic.h       |  421 +++++++++++++++++
>>>> drivers/scsi/snic/snic_attrs.c |   80 ++++
>>>> drivers/scsi/snic/snic_main.c  | 1022
>>>>++++++++++++++++++++++++++++++++++++++++
>>>> drivers/scsi/snic/snic_os.h    |   81 ++++
>>>> 4 files changed, 1604 insertions(+)
>>>> create mode 100644 drivers/scsi/snic/snic.h
>>>> create mode 100644 drivers/scsi/snic/snic_attrs.c
>>>> create mode 100644 drivers/scsi/snic/snic_main.c
>>>> create mode 100644 drivers/scsi/snic/snic_os.h
>>>
>>> Thanks,
>>>
>>> --
>>> Julian Calaby
>>>
>>> Email: julian.calaby@gmail.com
>>> Profile: http://www.google.com/profiles/julian.calaby/
>>
>
>
>
>-- 
>Julian Calaby
>
>Email: julian.calaby@gmail.com
>Profile: http://www.google.com/profiles/julian.calaby/

