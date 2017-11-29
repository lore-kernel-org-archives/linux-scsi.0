From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: Re: UFS utilities
Date: Wed, 29 Nov 2017 15:39:19 +0000
Message-ID: <e8aa9f0b9e854fe6bff7cb17dc08ce8c@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi, Greg

>On Mon, Nov 27, 2017 at 11:25:47AM +0000, Bean Huo (beanhuo) wrote:
>> Hi, all
>> Is there someone knows if exists one utilis dedicated to UFS device, rather
>than SCSI utils?
>> I have tried sg3-utils, but it is not convenient for the embedded ARM-based
>system.
>> And also it doesn't support several UFS special command.
>
>What specific UFS commands do you need to make to the device that the
>current driver does not support?


There are some UFS/vendor native commands. They are not SCSI based.

>And yes, this is a trick question as there are about 4 different major forks that
>I know of of the UFS driver in different vendor trees, all of which support
>different types of UFS commands :(
>
>> If we don't have this kind of tool for UFS, is it necessary for us to develop a
>>ufs-utils?
>
>I doubt it, what neds to happen is getting all of the functionality that lives in
>these different forks all merged upstream into the in-kernel driver.  Then I bet
>all of the needed functionality you are looking for will be there.
>
Sometimes customers tend to use user space tool to do some configuration.
And especially, for example the UFS FFU.

>good luck!
>
Thanks !
>greg k-h

//Bean Huo
