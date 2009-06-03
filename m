From: Kasper Sandberg <lkml@metanurb.dk>
Subject: Re: sata_sil24 0000:04:00.0: DMA-API: device driver frees DMA sg
	list  with different entry count [map count=13] [unmap count=10]
Date: Wed, 03 Jun 2009 22:21:43 +0200
Message-ID: <1244060503.11698.3.camel@localhost>
References: <64bb37e0905261214g2957924ar837339367f320d4c@mail.gmail.com>
	 <4A1C7DDB.9010605@gmail.com>
	 <64bb37e0906031230m22234268k9fdcd43dc1d35f18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755448AbZFCUVv@vger.kernel.org>
In-Reply-To: <64bb37e0906031230m22234268k9fdcd43dc1d35f18@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-06-03 at 21:30 +0200, Torsten Kaiser wrote:
> On Wed, May 27, 2009 at 1:40 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> > Torsten Kaiser wrote:
> >>
> >> On upgrading to 2.6.30-rc1 I enable the DMA-Debugging option
> >> CONFIG_DMA_API_DEBUG=y
> >> Since then I get the following or similar errors on each boot:
> >
> > Please retest with a newer -rc, this patch likely fixes it:
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5825627c9463581fd9e70f8285685889ae5bb9bb
> >
> 
> Still happens with 2.6.30-rc8 (see trace at the end of the email)
> 
<snip>

Does this actually give you any problems? should I be scared to give .30
a test?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
