From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [linux-usb-devel] 2.6.24: NULL scatter-gather pointer in usb_storage:usb_stor_access_xfer_buf?
Date: Thu, 31 Jan 2008 19:20:26 +0200
Message-ID: <47A2035A.8090500@panasas.com>
References: <Pine.LNX.4.44L0.0801311143180.3970-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0801311143180.3970-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Mark Glines <mark-6pk7R1svBr8dnm+yROfE0A@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 31 2008 at 18:45 +0200, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> On Thu, 31 Jan 2008, Boaz Harrosh wrote:
> 
>>>> Please check the below patch.
>>>>
>>>> one thing that I can see is that the isd200 does an INQUARY transfer
>>>> of sizeof(struct inquiry_data) which is 96 bytes, when scsi_scan.c
>>>> sends an INQUARY with 36 bytes buffer. So we have an underflow in 
>>>> usb_stor_access_xfer_buf().
> 
> Maybe the isd200 routine should be changed also, so that it doesn't try
> to store too much data in the buffer.
> 
>> I will send a proper patch to scsi maintainer. Alan is it OK to send this
>> patch threw James's scsi-misc?
> 
> You should send patches to Matt Dharm, since he is the usb-storage 
> maintainer.
> 
> Alan Stern
> 
> -
Right, Please see patch posted as reply to the original email.
I have also fixed isd200 to return what was asked. The fix
to protocol.c is also different and more general now.

Will send to Matthew Dharm.

Matthew - is it OK to send this threw James, please ACK.
Mark - this fix is different we do need testing.

Thanks to all
Boaz
