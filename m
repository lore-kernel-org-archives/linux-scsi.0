From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V5 2/2] scsi: ufs: Add configfs support for ufs
 provisioning
Date: Tue, 31 Jul 2018 10:48:25 +0530
Message-ID: <cd621e88-99c6-b2a0-8ab9-84761fb0a1f9@codeaurora.org>
References: <1530858040-13971-1-git-send-email-sayalil@codeaurora.org>
 <1530858040-13971-3-git-send-email-sayalil@codeaurora.org>
 <CAE=gft5U1-Jo-GvTF7sNAV3Q565AmuUrHpmBdxUL+UwkKxesqA@mail.gmail.com>
 <0dce9e9c-4f93-9857-72ee-f65ff195c41a@codeaurora.org>
 <CAE=gft6_=SQjgv7_kHXKJKa8_45NKKFwwE7UaXsijPpMd35LOg@mail.gmail.com>
 <4cb931e199599314829f5ff750797c88fc123f1f.camel@wdc.com>
 <CAE=gft6zm2mw3rnNuktDe0NWs-NM1CFQw1BUeGhaBi3eoEDXBg@mail.gmail.com>
 <8e6af8ed-1ec0-f10e-69b2-08281b638a4b@codeaurora.org>
 <CAE=gft4S9_H-PgpUHVrmjq4uah8pGKH+4A9xph+L=yButpqEpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft4S9_H-PgpUHVrmjq4uah8pGKH+4A9xph+L=yButpqEpA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: Bart.VanAssche@wdc.com, Vinayak Holikatti <vinholikatti@gmail.com>, linux-kernel@vger.kernel.org, asutoshd@codeaurora.org, riteshh@codeaurora.org, cang@codeaurora.org, martin.petersen@oracle.com, subhashj@codeaurora.org, linux-scsi@vger.kernel.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, jejb@linux.vnet.ibm.com, gregkh@linuxfoundation.org
List-Id: linux-scsi@vger.kernel.org



On 7/31/2018 5:09 AM, Evan Green wrote:
> On Mon, Jul 30, 2018 at 12:46 AM Sayali Lokhande <sayalil@codeaurora.org> wrote:
>> Hi Evan,
>>
>>
>> On 7/18/2018 1:53 AM, Evan Green wrote:
> ...
>>> I'm not dead set on binary, since as above I could do it either way,
>>> but it seemed worth at least talking through. Let me know what you
>>> think.
>>> -Evan
>> I am using ASCII format for reading/writing to config desc as it will be
>> more readable for users and easier/comfortable to compare any value to
>> default spec value(if required).
>> So I don't really see any harm in using current ASCII format for
>> provisioning purpose.
> I'm not convinced by those arguments, but ultimately it's between you
> and the maintainers. If you're going with the ASCII route, then I have
> another review comment. Currently in your patch, if kstrtoint fails,
> you print, but then break out of the loop and try to write the
> partially parsed descriptor anyway. That "break" should probably be
> changed to a "goto out".
>
> -Evan
Agreed. I will replace that break with "goto out" .
