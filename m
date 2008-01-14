From: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Subject: Re: PATCH: usb-storage-psc1350-v4.patch (was Linux scsi	/	usb-mass-storage
 and HP printer cardreader bug + fix)
Date: Mon, 14 Jan 2008 19:40:01 +0100
Message-ID: <478BAC81.2080101@s5r6.in-berlin.de>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com>	 <4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com>	 <4787CE08.5000304@hhs.nl> <1200303645.11301.15.camel@littletux>	 <478B2F90.7010105@hhs.nl>  <20080114160310.GH14375@one-eyed-alien.net> <1200328388.3159.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1200328388.3159.20.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, Guillaume Bedot <littletux-QFiJtcdG+fw@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, fedora-kernel-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, USB development list <linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, David Brown <usb-storage2-GijAUarxTbMdnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2008-01-14 at 08:03 -0800, Matthew Dharm wrote:
>> On Mon, Jan 14, 2008 at 10:46:56AM +0100, Hans de Goede wrote:
>> > Guillaume Bedot wrote:
>> > >Will this be possible to use "LAST_SECTOR_BUG" quirk for testing without
>> > >recompiling a kernel ?
>> > 
>> > This is not possible AFAIK, I've already wrote a blog post about this 
>> > asking for people to test this, but got no responses.
>> 
>> Once the patches are accepted by the SCSI people, one of the things we can
>> consider doing is enabling this quirk for all USB devices.
...
>> We may be able to convince the SCSI people to enable it for all devices,
>> regardless of HCD.
> 
> No ... I'm not particularly keen to have enterprise vendors after my
> blood ...

Guillaume, you can tell the SCSI core driver at boot time (or module
insertion time) and/or at runtime to
  - switch on default quirk flags,
  - add quirk flags for selected devices per name matching.

Alas I don't know of a good documention how to do either of this, and I
am not familiar enough with the procedure to explain it here.
-- 
Stefan Richter
-=====-==--- ---= -===-
http://arcgraph.de/sr/
