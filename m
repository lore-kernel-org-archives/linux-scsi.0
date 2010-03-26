From: Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [usb-storage] System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 26 Mar 2010 21:55:20 +0100
Message-ID: <4BAD1F38.5040007@gmail.com>
References: <4BA9D74F.9040507@gmail.com> <4BA7797F.8060605@gmail.com> <20100324155917.GA4382@xanatos> <59ca64281003241107x40c5d83co29d1ee03d8d3a0d1@mail.gmail.com> <20100326184021.GA4350@xanatos> <20100326192757.GA1187@one-eyed-alien.net> <20100326202358.GA22506@xanatos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100326202358.GA22506@xanatos>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 03/26/2010 09:23 PM, Sarah Sharp wrote:
> On Fri, Mar 26, 2010 at 12:27:57PM -0700, Matthew Dharm wrote:
>> I've got nothing.  BUT, usb-storage translates the command codes to names
>> via a table maintained by the SCSI people.  If it's not in the table, then
>> it's very likely coming from a userspace program.
>
> Probably from gpartd trying to partition the drive.

Can't be, the log I sent you was recorded by simply plugging in the 
drive and doing nothing else on the machine.

-Jonas
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
