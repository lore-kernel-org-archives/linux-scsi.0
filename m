From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: =?windows-1252?Q?Re=3A_Re=3A_Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD?=
	=?windows-1252?Q?=92s_in_scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5F?=
	=?windows-1252?Q?type=29?=
Date: Wed, 5 Oct 2011 22:29:21 +0530
Message-ID: <CADDb1s3FN4Ft2yXs-L8LfhoJEDP+KhSCrG8GGbOUgn_GXEr0yA@mail.gmail.com>
References: <CADDb1s0ZnHzM72sDnFmRrM=GFJtxj5JkYUSPo6GdyQ_=7L2m9A@mail.gmail.com>
	<Pine.LNX.4.44L0.1110041007070.1954-100000@iolanthe.rowland.org>
	<CADDb1s0taBR2=xpKE5rLJTWJBMbXijS8b_GEA-MbZvWKFDFvYg@mail.gmail.com>
	<CADDb1s3sPxpfNi-OD=QvVT+JWO9kUeTAmb8ZGyN0YCuBKWd4rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDb1s3sPxpfNi-OD=QvVT+JWO9kUeTAmb8ZGyN0YCuBKWd4rg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hi All,
Can anyone suggest what is the way ahead to detect the presence of
Write Cache in these kind of USB HDD and proceed accordingly by
assigning proper flushing method.
Please share some opinions on this.

Thanks & Regards,
Amit Sahrawat

On Wed, Oct 5, 2011 at 3:05 PM, Amit Sahrawat <amit.sahrawat83@gmail.co=
m> wrote:
> Hi,
>
> In order to verify the SYNC_CACHE command being passed.
> First I checked on the USB HDD(Seagate - Free Agent) which is gettind
> properly identified on linux. I performed - copy of a file and then
> did 'Safely Remove Hardware" - this resulted in SYNC_CACHE command
> being passed - All logs are captured for this.
>
> Then, for the same Hard Disk - I checked for the behaviour on Windows=
=2E
> There is no SYNC CACHE command being passed in this case.
>
> Again, checked for a different hard disk(Seagate) - which has cache
> but not shown in Linux. In that case also, there is no SYNC CACHE
> command.
>
> Please find the logs for the '3' cases attached.
>
> Thanks & Regards,
> Amit Sahrawat
>
> On Tue, Oct 4, 2011 at 9:04 PM, Amit Sahrawat <amit.sahrawat83@gmail.=
com> wrote:
>> On Tue, Oct 4, 2011 at 7:40 PM, Alan Stern <stern@rowland.harvard.ed=
u> wrote:
>>> On Tue, 4 Oct 2011, Amit Sahrawat wrote:
>>>
>>>> Not able to get tools which can show the Caching Information when
>>>> connected USB device to Windows 7(Except one option which allows f=
or
>>>> optimizing Performance by enabling/disabling Cache - But that opti=
on
>>>> is available for all the Mass storage device) - Please let me know=
 if
>>>> there is option to view this.
>>>
>>> I have no idea.
>>>
>>>> So, I have collected USB analyzer logs for Device after connected =
to
>>>> Windows 7. =A0Please find the attached logs.
>>>
>>> It would be more informative if your logs did not show the initial
>>> connection, but did show what happens when you write a small file t=
o
>>> the drive and then go through the "Safely Remove Hardware" procedur=
e.
>>>
>>> The real question is whether or not Windows sends a SYNCHRONIZE CAC=
HE
>>> command to the drive.
>> ok, I will try this out and provide the results tomorrow early morni=
ng.
>>>
>>> Alan Stern
>>>
>>>
>> Thanks & Regards,
>> Amit Sahrawat
>>
>
