From: Marc Bowes <marcbowes@gmail.com>
Subject: Re: SATA: link online but device misclassified
Date: Wed, 10 Jun 2009 22:40:07 +0200
Message-ID: <cfa4e840906101340o214ab8b8wa1e05f61d3d008e8@mail.gmail.com>
References: <cfa4e840906101331q71532d72v5361a72e9b77ce63@mail.gmail.com>
	 <20090610203421.GV3274@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090610203421.GV3274@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

The drive I just bought:
SEAGATE 160GB SATA 7200RPM HDD

The other is a Western Digital 500GB.

The ATA controllers: Intel Corporation 82801JI (ICH10 Family) 2 port
SATA IDE Controller.

To be honest, I'm not even too concerned about the link speed, I'm
more annoyed by the long timeout at boot time.

On Wed, Jun 10, 2009 at 10:34 PM, Matthew Wilcox<matthew@wil.cx> wrote:
> On Wed, Jun 10, 2009 at 10:31:32PM +0200, Marc Bowes wrote:
>> Greetings,
>>
>> Firstly, I hope that the SCSI list is the correct place to ask about=
 SATA.
>
> Not really, linux-ide is the preferred place.
>
>> I just got a new chipset (Gigabyte EP45-DQ6) courtesy of a
>> competition. This coincided with the death of a hard drive. I had to
>> reinstall my Gentoo system on the new hard drive, and hit this issue
>> when booting the newly configured Kernel (2.6.29-gentoo-r5):
>>
>> ata1: link is slow to respond, please be patient (ready=3D0)
>> ata1: softreset failed (device not ready)
>> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> ata1: link online but device misclassified, retrying
>> ata1: link is slow to respond, please be patient (ready=3D0)
>> ata1: softreset failed (device not ready)
>> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> ata1: link online but device misclassified, retrying
>> ata1: link is slow to respond, please be patient (ready=3D0)
>> ata1: softreset failed (device not ready)
>> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>> ata1: link online but device misclassified, retrying
>> ata1: limiting SATA link speed to 1.5 Gbps
>> ata1: softreset failed (device not ready)
>> ata1: SATA link up to 1.5 Gbps (SStatus 113 SControl 310)
>> ata1: link online but device misclassified, device detection might f=
ail
>> ata2: link is slow to respond, please be patient (ready=3D0)
>> ata2: softreset failed (device not ready)
>> ... (as with ata1)
>>
>> This whole process takes a very long time (minutes) to finish. It
>> seems to be down-grading two of the four SATA-2 drives to SATA-1
>> speeds. The drives are actually SATA-2 drives, and appear to work (a=
t
>> full speed) on my Windows 7 install.
>
> What drive model, what ATA controller, and have you checked you're re=
ally
> getting 250MB/s under Windows?
>
> --
> Matthew Wilcox =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Int=
el Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours. =A0We can't possibly take s=
uch
> a retrograde step."
>
