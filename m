From: Oliver Xymoron <oxymoron@waste.org>
Subject: Re: Hot plugging a disk in runtime
Date: Mon, 20 May 2002 17:33:43 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0205201730520.1277-100000@waste.org>
References: <E179lnL-0005Re-00@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <E179lnL-0005Re-00@the-village.bc.nu>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rabeeh Khoury <rabeeh@galileo.co.il>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 20 May 2002, Alan Cox wrote:

> > 1.. How is it possible to signal SCSI mid-layer (or other layers) of a
> > presence of a newly hot-plugged disk ?
>
> aacraid is one example that does this, but via its config tools.
>
> > 2.. Can an adapter's device driver trigger SCSI subsystem to scan
> > channels for new LUNs / Targets ?
>
> It is designed so user space can do so - so yes
>
> > 3.. Is this can be handled in a kernel level ? is there a user space
> > application that can be triggered to start scanning adapters (obviously
> > through SCSI subsystem) and registering new LUNs / Targets etc... ?
>
> echo "scsi-add-single-device a b c d" /proc/scsi/scsi
>
> if I remember it right

If I recall correctly, that code is more than a little bit racy. You're
probably just fine adding a device here and there, but adding a couple
dozen all at once makes things unhappy. Never finished debugging it though
- it seemed in need of a major rewrite.

-- 
 "Love the dolphins," she advised him. "Write by W.A.S.T.E.."

