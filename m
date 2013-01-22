From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [usb-storage] Re: Fwd: 2TB USB hard drive for backing up
Date: Tue, 22 Jan 2013 13:17:20 -0600
Message-ID: <2d90dddf-1bdc-4f43-bdf3-9ec09e38bb8b@email.android.com>
References: <Pine.LNX.4.44L0.1301221039350.1510-100000@iolanthe.rowland.org> <50FEC6D6.3030708@zytor.com> <1358874830.2387.46.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358874830.2387.46.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Ellwood Blues <elwood.blue-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Don't worry... I have lived in that world for decades... it's a lot like BIOS.

James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:

>On Tue, 2013-01-22 at 11:05 -0600, H. Peter Anvin wrote:
>> On 01/22/2013 09:43 AM, Alan Stern wrote:
>> > On Tue, 22 Jan 2013, Oliver Neukum wrote:
>> > 
>> >> On Tuesday 22 January 2013 11:05:35 James Bottomley wrote:
>> >>>> May  3 18:19:06 relampago3 kernel: [ 3948.472796] sd 7:0:0:0:
>[sdf]
>> >>>> 1565565872 512-byte logical blocks: (801 GB/746 GiB)
>> >>>
>> >>> This looks like a wrap around of your actual size.  This appears
>to
>> >>> indicate the device isn't replying correctly to READ CAPACITY. 
>The
>> >>> conventional return from READ CAPACITY should be -1 which would
>trigger
>> >>> us to retry with READ CAPACITY(16).
>> >>
>> >> What can we do? The answer the device is giving is quite ordinary.
>> >> Do we need another quirk and an associated flag?
>> > 
>> > The JMicron bridges are well known to be fairly buggy.  Another
>quirk 
>> > may indeed be the only solution.  Oliver, would you like to write a
>
>> > patch for it?
>> > 
>> 
>> Would it make more sense to try READ CAPACITY(16) first?  Or does
>that
>> have other bad effects?
>
>That has other effect: Many USB devices crash the firmware on 16 byte
>commands (sigh, welcome to our world ...)
>
>James

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
