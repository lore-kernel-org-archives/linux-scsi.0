From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] [RFC] [SCSI] mpt fusion: add support for 0x1000/0x0055
Date: Fri, 27 Jul 2012 22:11:16 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1207272210200.30412@pobox.suse.cz>
References: <alpine.LNX.2.00.1207210000190.21929@pobox.suse.cz> <alpine.LNX.2.00.1207271527550.11375@pobox.suse.cz> <CAHtARFHgG_8hQ85r5=W0E8d4BU-HVFLw7xkOFZA+H6kvH_83Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHtARFHgG_8hQ85r5=W0E8d4BU-HVFLw7xkOFZA+H6kvH_83Nw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Eric Moore <Eric.Moore@lsi.com>, James Bottomley <JBottomley@parallels.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 27 Jul 2012, adam radford wrote:

> >> The device identifies itself as
> >>
> >> 0d:05.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X
> >> Fusion-MPT SAS (rev 01) Subsystem: NEC Corporation SAS1068
> >>
> >> and seems to be functionally compatible with 0x0054 PID.
> >>
> >> The request for support of this device has been raised on mailinglists
> >> several
> >> times in the past (see [1] [2] and more), but aparently the PCI ID never
> >> made it
> >> to mptsas_pci_table[].
> >>
> >> [1] http://comments.gmane.org/gmane.linux.scsi/63836
> >> [2] http://lkml.indiana.edu/hypermail/linux/kernel/0701.2/1715.html
> >>
> >> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> >> ---
> >>
> >>
> >> I guess the "Subsystem: NEC Corporation" is telling us some rebranding
> >> story, including the PID change ... ?
> >
> > Hi guys,
> >
> > any feedback on this please?
> >
> > Thanks.
> 
> NACK.
> 
> Vendor 0x1000, Device id 0x0055 is actually an old LSI MegaRAID 1068
> based software raid board.  This device was never qualified nor
> intended to be used with the mpt fusion driver.

So, what is the alternative?

The only thing I know is that it works at least in basic mode (haven't 
tested performance at all).

Thanks,

-- 
Jiri Kosina
SUSE Labs
