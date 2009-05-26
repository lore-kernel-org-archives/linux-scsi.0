From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Tue, 26 May 2009 08:56:05 +0100
Message-ID: <20090526085605.014d0087@lxorguk.ukuu.org.uk>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
	<1243230339.9819.18.camel@localhost.localdomain>
	<4A1A4A54.6090401@lemote.com>
	<200905251656.25357.bzolnier@gmail.com>
	<4A1AEBF7.7040402@ru.mvista.com>
	<yq1tz39dmmn.fsf@sermon.lab.mkp.net>
	<1243300890.9819.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1243300890.9819.40.camel@localhost.localdomain>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
To: yanh@lemote.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?UTF-8?B?6IOh5rSq5YW1?= <huhb@lemote.com>, wuzhangjin@gmail.com, linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>
List-Id: linux-scsi@vger.kernel.org

> > In any case I have yet to see a CS5536 system whose BIOS sets the cable
> > detection bit.  If that's the problem I guess we could add a quirk flag
> > to override the (lack of) BIOS setting.
> > 
> This may be the cause that udma5 cannot be set.


If the system doesn't have working BIOS cable detect as per the
documentation for the chip then just return the "unknown" cable type and
libata will do device side cable detect.

Alan
