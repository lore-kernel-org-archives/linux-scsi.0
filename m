From: Steven Dake <sdake@mvista.com>
Subject: Re: A different look at block device hotswap in the Linux kernel
Date: Thu, 23 Jan 2003 14:06:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E30595C.5070808@mvista.com>
References: <20030123130715.S95542-100000@wonky.in0.lcl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030123130715.S95542-100000@wonky.in0.lcl>
List-Id: linux-scsi@vger.kernel.org
To: mjacob@feral.com
Cc: Oliver Neukum <oliver@neukum.name>, Luben Tuikov <luben@splentec.com>, Alan Stern <stern@rowland.harvard.edu>, David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

I cant speak about OS/X, but I have crashed windows several times (BSOD) 
while hot removing a USB SCSI CDROM.  As you will notice, when you run 
windows and attach a device, there is a program that is started that 
allows you to notify the os of the removal so that it may properly 
remove the device from the OS instead of it being yanked.

Thanks
-steve

Matthew Jacob wrote:

>>The key is that the removal request should come from the top, not the
>>bottom.  If someone is stupid enough to surprise remove a device (ie:
>>unplug their USB SCSI device while the device is in use by the OS), they
>>get what they deserve (I/O errors, dirty OS data, queued up requests
>>which never shut down).  If they tell the OS that the device is going to
>>be removed, so it may flush the device and shut down I/O to the device,
>>the request should be granted on all accounts (expected removal).
>>
>>    
>>
>
>Hmm? Windows and OS/X cope with this just fine.
>
>
>
>
>  
>

