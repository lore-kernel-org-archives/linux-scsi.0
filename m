From: Dave Olien <dmo@osdl.org>
Subject: Re: [ANNOUNCE] multipath-tools-0.3.1
Date: Tue, 12 Oct 2004 11:35:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041012183529.GA27921@osdl.org>
References: <1096071849.4466.31.camel@zezette> <1097054573.4163b96d1262c@imp5-q.free.fr> <1097495416.416a73787e0ae@imp1-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1097495416.416a73787e0ae@imp1-q.free.fr>
To: christophe.varoqui@free.frf
Cc: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christophe,

I compiled and installed your new tarball.  It looks good so far on i386.
Thanks for the update!

Dave

On Mon, Oct 11, 2004 at 01:50:16PM +0200, christophe.varoqui@free.fr wrote:
> Hello,
> 
> here goes multipath-tools-0.3.1
> 
> Early release, to fix a important i386 breakage due to regparm switch in klibc.
> Release focuses on undusting kpartx.
> ia64 and woody testers, please redo your thing : I may have got it right this
> time.
> 
> Full ChangeLog for the release :
> 
>         * [kpartx] move back to getopt, originaly removed from the
>           original partx because of lack of implementation in klibc
>         * [kpartx] don't map extended partitions
>         * [kpartx] add a -p command flag to allow admin to force a
>           delimiting string between disk name and part number. When
>           specified always use it, when unspecified use 'p' as a delim
>           when last char of disk name is a digit, NUL otherwise.
>         * [kpartx] clean up
>         * bump klibc to 0.182
>         * one step further : use klibc MCONFIG for all klibc specific
>           FLAGS definitions, ie massive Makefile.inc cleanup
>         * follow the klibc compilation rules by appending its OPTFLAGS
>           to multipath-tools' CFLAGS. This corrects the segfaults seen
>           on i386 where klibc is built with regparm=3 and tools are not
>         * [multipathd] fall back to fork when clone not available
>           like in Debian Woody
>         * [kpartx] move .start and .size from uint to ulong (Ake)
>         * briefly document system-disk-on-multipath in the FAQ file
> 
> As usual, doc and download at :
> http://christophe.varoqui.free.fr/
> 
> regards,
> --
> christophe varoqui <christophe.varoqui@free.fr>
> 
> 
> -------------------------------------------------------
> This SF.net email is sponsored by: IT Product Guide on ITManagersJournal
> Use IT products in your business? Tell us what you think of them. Give us
> Your Opinions, Get Free ThinkGeek Gift Certificates! Click to find out more
> http://productguide.itmanagersjournal.com/guidepromo.tmpl
> _______________________________________________
> Linux-hotplug-devel mailing list  http://linux-hotplug.sourceforge.net
> Linux-hotplug-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel
