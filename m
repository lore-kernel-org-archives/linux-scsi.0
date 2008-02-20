From: Andrew Buehler <abuehler.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly resolved
Date: Wed, 20 Feb 2008 13:27:13 -0500
Message-ID: <47BC7101.4060501@gmail.com>
References: <Pine.LNX.4.44L0.0802201213260.5630-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0802201213260.5630-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Oliver Pinter <oliver.pntr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kernel development list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 2/20/2008 12:15 PM, Alan Stern wrote:

> On Wed, 20 Feb 2008, Andrew Buehler wrote:

>> Hmm. One thing which just sprang to mind, in the stab-in-the-dark
>> category: in 2.6.24.2, launching the program on some machines gave
>> warnings along the lines of "this program is using a deprecated
>> ioctl, please convert it to SG_IO" (which I naturally cannot do
>> since it's closed and I don't have the source),
> 
> You can ask the program's author to update it.

It's provided by Novell, with whom I have no direct contact and am not
presently authorized to speak on behalf of my organization. From what I
have read about the history of their support on this program and these
discs, I do not expect that they would be willing to support it except
in environments which they provide in monolithic form; it would be
possible for me to copy an updated version of the program out of such an
environment to use in my own customized one, but I am not certain that
they have even created such an updated version, and in any case
obtaining it would almost certainly require buying the latest version of
Novell ZENworks - which my organization is certainly not prepared to do
at the present time.

In other words: I don't think that's likely to be practical in the
present instance. If you have reason to believe otherwise (past positive
experience with Novell, for instance), I'd be glad to hear it.

>> I'm not sure I expressed myself clearly. I do not think the problem
>> is with the different kernels. I think the problem is with the
>> different configurations. I am asking if there are any established
>> techniques for comparing differences between config files from
>> widely different kernels.
> 
> Not as far as I know.

Oh, well... thanks anyway.

Is there any place (aside from maybe the kernel changelog, which
contains a whole lot - if not several lots - of unrelated information)
where I could find a list of config-symbol name additions, changes,
deletions and meaning changes by version or by date? That would at least
let me build a mapping between the symbols in the older config and the
ones in the new one, which is about where I would have to start.

-- 
    Andrew Buehler
