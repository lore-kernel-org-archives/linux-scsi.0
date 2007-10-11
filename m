From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCHES] Re: sil3114 data corruption
Date: Thu, 11 Oct 2007 14:09:55 +0200
Message-ID: <200710111409.56210.bs@q-leap.de>
References: <200710081709.18253.bs@q-leap.de> <200710101112.20448.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200710101112.20448.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 10 October 2007 11:12:20 Bernd Schubert wrote:
> On Monday 08 October 2007 17:09:17 Bernd Schubert wrote:
> > [sorry for sending twice, but after I read the sil sources, I see the
> > mail address had been wrong]
> >
> > Hi,
> >
> > somehow the sil3114 causes data corruption with some (newer?) disks.
> > Simply filling the filesystem with zeros and reading the these data will
> > make the kernel to report filesystem corruption.
> > This is definitely not an issue of memory, since the systems (several
> > tested) do have ECC memory and the memory is monitored with EDAC.
> >
> > kernel versions tested: 2.6.15-2.6.20
>
> Update: Setting sata_sil.slow_down=1 fill fix the problem, seems there are
> some drives missing in the quirk table.
>
> Jeff, I found an old patch/workaround from you
> (http://uwsg.indiana.edu/hypermail/linux/kernel/0403.1/1957.html), can you
> give me any further information why this never went into the driver?
>

I will send 3 mails with patches to fix this corruption.


-- 
Bernd Schubert
Q-Leap Networks GmbH
