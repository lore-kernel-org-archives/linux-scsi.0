From: Kyuho Choi <chlrbgh0@gmail.com>
Subject: Re: UFS utilities
Date: Mon, 4 Dec 2017 11:47:38 +0900
Message-ID: <CAP2JTQ+zPDEXQeRanE48OPqBMwGRo-bJKdaVh-bBZCEDpZKenA@mail.gmail.com>
References: <e8aa9f0b9e854fe6bff7cb17dc08ce8c@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e8aa9f0b9e854fe6bff7cb17dc08ce8c@SIWEX5A.sing.micron.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

On 11/30/17, Bean Huo (beanhuo) <beanhuo@micron.com> wrote:
> Hi, Greg
>
>>On Mon, Nov 27, 2017 at 11:25:47AM +0000, Bean Huo (beanhuo) wrote:
>>> Hi, all
>>> Is there someone knows if exists one utilis dedicated to UFS device,
>>> rather
>>than SCSI utils?
>>> I have tried sg3-utils, but it is not convenient for the embedded
>>> ARM-based
>>system.
>>> And also it doesn't support several UFS special command.
>>
>>What specific UFS commands do you need to make to the device that the
>>current driver does not support?
>
>
> There are some UFS/vendor native commands. They are not SCSI based.
>

UFS command means uic/dme commands?.
AFAIK, many uic/dme commands need  pre/post operation of SoC related.
So, it would be need modify sg3-utils or another.

Therefore, IMHO, I don't know why we need it. But if you still want
it, You'll be need to modify/create user application and modified ufs
driver for your needs.

About vendor command, it's vendor specific.
It'll be possible to support by sg3-utils. And it need modify too.

>>And yes, this is a trick question as there are about 4 different major
>> forks that
>>I know of of the UFS driver in different vendor trees, all of which
>> support
>>different types of UFS commands :(
>>
>>> If we don't have this kind of tool for UFS, is it necessary for us to
>>> develop a
>>>ufs-utils?
>>
>>I doubt it, what neds to happen is getting all of the functionality that
>> lives in
>>these different forks all merged upstream into the in-kernel driver.  Then
>> I bet
>>all of the needed functionality you are looking for will be there.
>>
> Sometimes customers tend to use user space tool to do some configuration.
> And especially, for example the UFS FFU.
>

As i knew, in case of FFU, it's possible to support by sg_write_buffer.

>>good luck!
>>
> Thanks !
>>greg k-h
>
> //Bean Huo
>
>

WBR,
Kyuho Choi
