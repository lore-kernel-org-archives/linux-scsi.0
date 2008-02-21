From: Andrew Buehler <abuehler.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly resolved
Date: Thu, 21 Feb 2008 11:05:21 -0500
Message-ID: <47BDA141.70806@gmail.com>
References: <Pine.LNX.4.44L0.0802201428390.7056-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0802201428390.7056-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Oliver Pinter <oliver.pntr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kernel development list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 2/20/2008 2:29 PM, Alan Stern wrote:

> On Wed, 20 Feb 2008, Andrew Buehler wrote:
> 
>> In other words: I don't think that's likely to be practical in the
>> present instance. If you have reason to believe otherwise (past
>> positive experience with Novell, for instance), I'd be glad to hear
>> it.
> 
> Greg KH may be able to help in that respect.

I know he's in the CC:, but I'm not sure he's reading this thread, and
I'm hesitant to bother people about things out of the blue unless I have
reason to expect that it's something they're going to care about. (Just
because it's a big deal for me doesn't mean it makes one whit of
difference to anyone else, and from what little I've seen on
linux-kernel he seems to be somewhat important and fairly busy...)

>> Is there any place (aside from maybe the kernel changelog, which
>> contains a whole lot - if not several lots - of unrelated
>> information) where I could find a list of config-symbol name
>> additions, changes, deletions and meaning changes by version or by
>> date? That would at least let me build a mapping between the
>> symbols in the older config and the ones in the new one, which is
>> about where I would have to start.
> 
> Not as far as I know.

Then I suppose I'm reduced to browsing the Kconfig files, reading old
changelogs, and trying a lot of different configs... thanks anyway.

-- 
    Andrew Buehler
