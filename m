From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: =?windows-1252?Q?Re=3A_Re=3A_Re=3A_BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD?=
	=?windows-1252?Q?=92s_in_scsiglue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5F?=
	=?windows-1252?Q?type=29?=
Date: Tue, 4 Oct 2011 21:04:49 +0530
Message-ID: <CADDb1s0taBR2=xpKE5rLJTWJBMbXijS8b_GEA-MbZvWKFDFvYg@mail.gmail.com>
References: <CADDb1s0ZnHzM72sDnFmRrM=GFJtxj5JkYUSPo6GdyQ_=7L2m9A@mail.gmail.com>
	<Pine.LNX.4.44L0.1110041007070.1954-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1110041007070.1954-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 4, 2011 at 7:40 PM, Alan Stern <stern@rowland.harvard.edu> =
wrote:
> On Tue, 4 Oct 2011, Amit Sahrawat wrote:
>
>> Not able to get tools which can show the Caching Information when
>> connected USB device to Windows 7(Except one option which allows for
>> optimizing Performance by enabling/disabling Cache - But that option
>> is available for all the Mass storage device) - Please let me know i=
f
>> there is option to view this.
>
> I have no idea.
>
>> So, I have collected USB analyzer logs for Device after connected to
>> Windows 7. =A0Please find the attached logs.
>
> It would be more informative if your logs did not show the initial
> connection, but did show what happens when you write a small file to
> the drive and then go through the "Safely Remove Hardware" procedure.
>
> The real question is whether or not Windows sends a SYNCHRONIZE CACHE
> command to the drive.
ok, I will try this out and provide the results tomorrow early morning.
>
> Alan Stern
>
>
Thanks & Regards,
Amit Sahrawat
