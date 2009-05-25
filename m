From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Mon, 25 May 2009 23:17:16 +0400
Message-ID: <4A1AEEBC.2080108@ru.mvista.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com>	<1243230339.9819.18.camel@localhost.localdomain>	<4A1A4A54.6090401@lemote.com> <200905251656.25357.bzolnier@gmail.com>	<4A1AEBF7.7040402@ru.mvista.com> <yq1tz39dmmn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1tz39dmmn.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?UTF-8?B?6IOh5rSq5YW1?= <huhb@lemote.com>, yanh@lemote.com, wuzhangjin@gmail.com, linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>
List-Id: linux-scsi@vger.kernel.org

Hello.

Martin K. Petersen wrote:

>>>Could you please explain the issue with platform specific code a bit
>>>more?

>>>Is it related to a cable detection by any chance?

> Sergei>    I guess it's rdmsr()/wrmsr()...

> Those are only used when the driver is explicitly loaded with
> use_msr=1.  The default is to use PCI config space/VSA.

    But you need them defined for the driver to build...

MBR, Sergei
