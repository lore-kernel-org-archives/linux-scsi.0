From: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 9 Apr 2010 10:14:24 -0700
Message-ID: <20100409171424.GA5906@xanatos>
References: <Pine.LNX.4.44L0.1004091118260.1852-100000@iolanthe.rowland.org>
 <4BBF582F.4040707@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4BBF582F.4040707-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dinh.Nguyen-KZfg59tc24xl57MIdRCFDg@public.gmane.org
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Jonas Schwertfeger <jschwertfeger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Lord <mlord-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>, Sergei Shtylyov <sshtylyov-Igf4POYTYCDQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, David Zeuthen <david-o55+BOBDEFg@public.gmane.org>, linux-hotplug-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 09, 2010 at 12:39:11PM -0400, Douglas Gilbert wrote:
> Alan Stern wrote:
> >On Wed, 7 Apr 2010, Jonas Schwertfeger wrote:
> >
> >>On 04/07/2010 05:03 PM, Alan Stern wrote:
> >>>In that case, can you repeat the test using an EHCI controller instead
> >>>of xHCI?
> >
> >>ffff8800345dbb40 2336460054 S Bo:1:004:2 -115 31 = 55534243
> >>96000000 00020000 80001085 082e0000 00010000 00000000 40a100
> >>ffff8800345dbb40 2336460204 C Bo:1:004:2 0 31 >
> >>ffff880035f30f00 2336460222 S Bi:1:004:1 -115 512 <
> >>ffff880035f30f00 2336460472 C Bi:1:004:1 -32 0
> >>ffff8800345dbb40 2336460492 S Co:1:004:0 s 02 01 0000 0081 0000 0
> >>ffff8800345dbb40 2336460579 C Co:1:004:0 0 0
> >>ffff8800345dbb40 2336460596 S Bi:1:004:1 -115 13 <
> >>ffff8800345dbb40 2336460711 C Bi:1:004:1 0 13 = 55534253
> >>96000000 00020000 01
> >>ffff8800345dbb40 2336460729 S Bo:1:004:2 -115 31 = 55534243
> >>97000000 60000000 80000603 00000060 00000000 00000000 000000
> >>ffff8800345dbb40 2336460823 C Bo:1:004:2 0 31 >
> >>ffff880035f30f00 2336460841 S Bi:1:004:1 -115 96 <
> >>ffff880035f30f00 2336460952 C Bi:1:004:1 0 96 = 720b0000
> >>0000000e 090c0004 00010000 00000000 40510000 00000000 00000000
> >
> >Here's the sense information for the failed ATA-16 passthrough
> >command.  I can't interpret it; maybe someone else can.
> 
> Descriptor sense format, sense_key=ABORTED_COMMAND
> with no additional sense code (0x0,0x0).
> 
> It has also added an ATA Return descriptor which
> purports to be the ATA registers after the command
> is processed. That starts at the 0x09 byte. See
> sat2r09.pdf table 114 to decode that.
> Since it is an aborted command I would not take
> that too seriously.
> 
> It is incorrect to have an ATA Return descriptor
> with asc,ascq=0x0,0x0 .

Someone should probably tell Neil Perng at Genesys Logic.  Maybe Dinh
Nguyen (from the launchpad entry) can provide an email address or
forward this thread on?

Sarah Sharp
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
