From: Nikola Pajkovsky <npajkovsky@suse.cz>
Subject: Re: [PATCH v2 22/30] scsi: aacraid: Merge adapter setup with resolve luns
Date: Thu, 04 Jan 2018 13:36:56 +0100
Message-ID: <878tdd242f.fsf@suse.cz>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
        <20171227043451.27813-23-RaghavaAditya.Renukunta@microsemi.com>
        <87h8s31crn.fsf@suse.cz>
        <62b6c88e782c46fe8d502f49a8d885cc@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60785 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751940AbeADMg7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jan 2018 07:36:59 -0500
In-Reply-To: <62b6c88e782c46fe8d502f49a8d885cc@microsemi.com> (Raghava Aditya
        Renukunta's message of "Wed, 3 Jan 2018 17:00:57 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Scott Benesh <scott.benesh@microsemi.com>, Tom White <tom.white@microsemi.com>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com> writes:

> Hi Nikola,
>
>> -----Original Message-----
>> From: Nikola Pajkovsky [mailto:npajkovsky@suse.cz]
>> Sent: Wednesday, January 3, 2018 2:02 AM
>> To: Raghava Aditya Renukunta
>> <RaghavaAditya.Renukunta@microsemi.com>
>> Cc: jejb@linux.vnet.ibm.com; martin.petersen@oracle.com; linux-
>> scsi@vger.kernel.org; Scott Benesh <scott.benesh@microsemi.com>; Tom
>> White <tom.white@microsemi.com>; dl-esc-Aacraid Linux Driver
>> <aacraid@microsemi.com>; Guilherme G . Piccoli
>> <gpiccoli@linux.vnet.ibm.com>; Bart Van Assche
>> <Bart.VanAssche@wdc.com>
>> Subject: Re: [PATCH v2 22/30] scsi: aacraid: Merge adapter setup with resolve
>> luns
>> 
>> EXTERNAL EMAIL
>> 
>> 
>> Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
>> writes:
>> 
>> > The device hotplug events are processed only after retrieving the updated
>> > lun information from the fw. Does not make sense to keep them separate.
>> >
>> > Merge both the hotplug handling and safw adapter setup code into single
>> > function.
>> >
>> > Signed-off-by: Raghava Aditya Renukunta
>> <RaghavaAditya.Renukunta@microsemi.com>
>> 
>> According to subsequent commit
>> 
>>   [PATCH v2 23/30] scsi: aacraid: Block concurrent hotplug event handling
>> 
>> this commit is racy, because 23/30 adds ->scan_mutex. Shouldn't be these
>> commits squashed?
>
> I tried to make the patches as logically distinct as possible, maybe I
> got a bit too ambitious and I expected the patches to go thru as a set so
> I don’t think it would make any difference. What do you think?

It does make difference, when you start cherry-picking patches to
downstream kernel. However, I don't have strong opinion here, so it can
stay as is.

-- 
Nikola
