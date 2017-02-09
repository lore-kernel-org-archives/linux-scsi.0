From: ojab <ojab@ojab.ru>
Subject: Re: [PATCH V2] mpt3sas: disable ASPM for MPI2 controllers
Date: Thu, 9 Feb 2017 09:52:44 +0000
Message-ID: <dab2f17c-c18b-e03b-5ca9-3c9d5c18dd5b@ojab.ru>
References: <20161228110524.7516-1-ojab@ojab.ru>
 <CAK=zhgoEep5afmFq05kn0bxhuykSQH_BJE3ZzJrhzr+Y3M23vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34818 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752180AbdBIKAt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2017 05:00:49 -0500
Received: by mail-lf0-f67.google.com with SMTP id v186so11607834lfa.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2017 02:00:49 -0800 (PST)
In-Reply-To: <CAK=zhgoEep5afmFq05kn0bxhuykSQH_BJE3ZzJrhzr+Y3M23vw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2017/02/09 05:09, Sreekanth Reddy wrote:
> On Wed, Dec 28, 2016 at 4:35 PM, ojab <ojab@ojab.ru> wrote:
>> MPI2 controllers sometimes got lost (i. e. disappears from
>> /sys/bus/pci/devices) if ASMP is enabled.
>>
>> Signed-off-by: Slava Kardakov <ojab@ojab.ru>
>> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=60644
>
> From some of our system engineers team, I came to known that ASPM
> needs to be disabled.
> So this patch looks good. Please consider this patch as
>
> Acked-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

Yay, thanks!

I assume that this patch should also be CC: stable@, since it's clearly 
a rather critical bugfix.

Is it too late for 4.10.0?

//wbr ojab
>
> Thanks,
> Sreekanth
