From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH v3 2/4] usb: storage: add support for write cache quirk on
 usb hdd
Date: Tue, 12 Jun 2012 07:50:01 +0900
Message-ID: <CAKYAXd88oU_vu4Ko4x+OAi3=w8CLSD0GEA787-3CMVfXL6CLQg@mail.gmail.com>
References: <1339263660-4039-1-git-send-email-linkinjeon@gmail.com>
	<4FD39904.2010808@mvista.com>
	<CAKYAXd9EUqxUBw1YWr2FnBrg1K=uGWiaEFYtSgu-J3nZ9sLvuQ@mail.gmail.com>
	<4FD626C1.1010507@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FD626C1.1010507@mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: James.Bottomley@hansenpartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, bvanassche@acm.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

2012/6/12, Sergei Shtylyov <sshtylyov@mvista.com>:
> Hello.
>
> On 10-06-2012 4:30, Namjae Jeon wrote:
>
>>>> Add support for write cache quirk on usb hdd. scsi driver will be set
>>>> to
>>>> wce
>>>> by detecting write cache quirk in quirk list when plugging usb hdd.
>
>>>> Signed-off-by: Namjae Jeon<namjae.jeon@samsung.com>
>>>> Signed-off-by: Pankaj Kumar<pankaj.km@samsung.com>
>>>> Signed-off-by: Amit Sahrawat<a.sahrawat@samsung.com>
>>>> ---
>>>>    drivers/usb/storage/scsiglue.c |    5 +++++
>>>>    drivers/usb/storage/usb.c      |    5 ++++-
>>>>    include/linux/usb_usual.h      |    4 +++-
>>>>    3 files changed, 12 insertions(+), 2 deletions(-)
>
>>>> diff --git a/drivers/usb/storage/scsiglue.c
>>>> b/drivers/usb/storage/scsiglue.c
>>>> index a324a5d..fe42547 100644
>>>> --- a/drivers/usb/storage/scsiglue.c
>>>> +++ b/drivers/usb/storage/scsiglue.c
>>> [...]
>>>> @@ -529,6 +529,9 @@ static void adjust_quirks(struct us_data *us)
>>>>    		case 'o':
>>>>    			f |= US_FL_CAPACITY_OK;
>>>>    			break;
>>>> +		case 'p':
>>>> +			f |= US_FL_WRITE_CACHE;
>>>> +			break;
>>>>    		case 'r':
>>>>    			f |= US_FL_IGNORE_RESIDUE;
>>>>    			break;
>>>
>>>      You probably should unite this chunk with the documentation update
>>> patch.
>
>> Hi Sergei.
>> I tried to post documentation update patch(4/4) for this chunk.
>> Do I misunderstand ?
>
>     I mean that the documenation should be updated in the same patch where
> you
> add the new value.
Okay, I changed it on the latest patch also.
Sergei, Thanks a lot.
>
> WBR, Sergei
>
