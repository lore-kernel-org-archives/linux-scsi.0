From: "Nicholas Berry" <nikberry@med.umich.edu>
Subject: Re: 2.4.20 scsi problem
Date: Tue, 03 Dec 2002 07:22:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <sdec5bb0.087@mail-01.med.umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, eric@rti-zone.org
Cc: groudier@free.fr, axboe@suse.de, linux-scsi@vger.kernel.org

Hi.

Do you have an entry like:

       alias block-major-8 sd_mod 

in /etc/modules.conf?

Nik

> >>> Eric GAUDET <eric@rti-zone.org> 12/03/02 02:27AM >>>
> -- En reponse de "Re: 2.4.20 scsi problem" de Alan Cox, le 02-Dec-2002 :
> > On Mon, 2002-12-02 at 06:58, Eric GAUDET wrote:
> >> # SCSI low-level drivers
> >> #
> >> (none set)
> > 
> > That sounds like your problem to me
>
> Unfortuately, as I said in my earlier message:
> >> Compiling sd as a module instead of in the kernel does not seem to change
> >> anything. Nor compiling with a scsi low-level driver. It seems that I need an
> >> actual scsi device at boot time in order to see block device 8 (not tested, I
> >> don t have such a device)


