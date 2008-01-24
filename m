From: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Subject: Re: PATCH: usb-storage-set-last-sector-bug-flag.patch
Date: Thu, 24 Jan 2008 18:22:57 +0100
Message-ID: <4798C971.8090008@s5r6.in-berlin.de>
References: <20080120205625.GB28842@kroah.com> <Pine.LNX.4.44L0.0801201642460.8504-100000@netrider.rowland.org> <20080123181239.GA21836@kroah.com> <4798C5B4.1000208@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4798C5B4.1000208-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, Matthew Dharm <mdharm-scsi-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, USB development list <linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, David Brown <usb-storage2-GijAUarxTbMdnm+yROfE0A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

> The last-sector-(access-)bug workaround _only_ modifies the command
> stream which is sent to the device.  A dangerous command is replaced by
> equivalent safe commands.

BTW, one thing about this patch set needs to be criticized:

"last_sector_bug" is a really bad name choice for the new flag.  No
wonder that it is confused with the (well named) "fix_capacity" flag.

How about "read_last_sector_separately" or something in the way?
-- 
Stefan Richter
-=====-==--- ---= ==---
http://arcgraph.de/sr/
