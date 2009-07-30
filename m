From: rohan a <info1686@gmail.com>
Subject: Re: SCSI command (SP-OUT) failing on SLES 9 32-bit
Date: Thu, 30 Jul 2009 11:06:59 +0530
Message-ID: <7a7c22420907292236x1b528153pe22e53473c22626a@mail.gmail.com>
References: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>
	 <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>
	 <7a7c22420907150803v4f4ae9dn9eff41b5d5a7edf6@mail.gmail.com>
	 <1247670563.4236.16.camel@mulgrave.site> <4A645FCE.5030506@suse.de>
	 <7a7c22420907220626t11f510b7q835add0d5b7ecc94@mail.gmail.com>
	 <7a7c22420907280357p71c495f8x9923227eef000391@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751420AbZG3FhB@vger.kernel.org>
In-Reply-To: <7a7c22420907280357p71c495f8x9923227eef000391@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,
      I checked var/log/messages
These are the errors reported:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
kernel: mptbase: ioc0: IOCStatus(0x0003): Invalid SGL
kernel: mptbase: ioc0: LogInfo(0x11070000): F/W: DMA Error
kernel: mptbase: ioc0: LogInfo(0x11070000): F/W: DMA Error
kernel: mptbase: ioc0: IOCStatus(0x004b): SCSI IOC Terminated
kernel: st0: Error with sense data: Current st0: sense key Unit Attenti=
on
kernel: Additional sense: Scsi bus reset occurred
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

Thanks


On 7/28/09, rohan a <info1686@gmail.com> wrote:
> Hi all/Hannes,
>
> Any help/suggestions?
>
>
> On Wed, Jul 22, 2009 at 6:56 PM, rohan a<info1686@gmail.com> wrote:
> > Hi,
> >       Thanks for a reply.
> > I have 2 SLES 9 32-bit machines, on one I am using an FC HBA card a=
nd
> > another a SCSI HBA card to connect LTO-4 standalone drives and driv=
e
> > based encryption is not working in both cases.
> >
> > Thanks
> >
> > On Mon, Jul 20, 2009 at 5:45 PM, Hannes Reinecke<hare@suse.de> wrot=
e:
> >> James Bottomley wrote:
> >>> On Wed, 2009-07-15 at 20:33 +0530, rohan a wrote:
> >>>> Hi guys,
> >>>>
> >>>> Any suggestions...please help
> >>>
> >>> I know of no kernel bug that could be causing this.  The SLES9 ke=
rnel is
> >>> just too old though for me to remember clearly.  I'd suggest you =
file a
> >>> support incident with SUSE ... they'll debug and fix this on the =
older
> >>> kernels; we really only deal with the new kernel and one or two b=
ack
> >>> revisions here on linux-scsi.
> >>>
> >> You did that on purpose.
> >> The 'they' is actually me :-(
> >>
> >> Actually, there already _is_ a bug, so no need to open another one=
=2E
> >> Which HBA are you using?
> >>
> >> Cheers,
> >>
> >> Hannes
> >> --
> >> Dr. Hannes Reinecke                   zSeries & Storage
> >> hare@suse.de                          +49 911 74053 688
> >> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> >> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
> >>
> >
>
