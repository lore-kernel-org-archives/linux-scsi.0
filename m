From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v2 5/6] esp_scsi: De-duplicate PIO routines
Date: Mon, 15 Oct 2018 13:32:54 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810151332060.10@nippy.intranet>
References: <cover.1539497520.git.fthain@telegraphics.com.au> <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au> <CAMuHMdV6cuXngfmCBbqPsyAZDcFo9sO=F-TYy+OyS5vEOou0eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdV6cuXngfmCBbqPsyAZDcFo9sO=F-TYy+OyS5vEOou0eQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, scsi <linux-scsi@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 14 Oct 2018, Geert Uytterhoeven wrote:

> 
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -42,6 +42,10 @@ config SCSI_DMA
> >         bool
> >         default n
> >
> > +config SCSI_ESP_PIO
> > +       bool
> > +       default n
> 
> "default n" is the default, so please drop this line.
> 

Done. Thanks.

-- 
