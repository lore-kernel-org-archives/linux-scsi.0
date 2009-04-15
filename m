From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: 2.6.30-rc1: parisc: system hangs on boot at __schedule()
Date: Wed, 15 Apr 2009 16:49:03 +0400
Message-ID: <a4423d670904150549s48b844a7iba097acaf875b992@mail.gmail.com>
References: <a4423d670904080603w50face2fl87cd16bd7967cb5d@mail.gmail.com>
	 <20090408220921.GF7372@bombadil.infradead.org>
	 <a4423d670904090146w2937bf15le2afb5dfad718f0e@mail.gmail.com>
	 <20090409144611.GH7372@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20090409144611.GH7372@bombadil.infradead.org>
Sender: linux-parisc-owner@vger.kernel.org
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-parisc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Kernel Testers List <kernel-testers@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2009/4/9 Kyle McMartin <kyle@mcmartin.ca>:
> On Thu, Apr 09, 2009 at 12:46:15PM +0400, Alexander Beregalov wrote:
>> 2009/4/9 Kyle McMartin <kyle@mcmartin.ca>:
>> > On Wed, Apr 08, 2009 at 05:03:04PM +0400, Alexander Beregalov wrote:
>> >> Hi
>> >>
>> >> Machine is HP j6000.
>> >> CPU(s): 2 x PA8700 (PCX-W2) at 750.000000 MHz
>> >>
>> >> gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1, pie-10.1.5)
>> >>
>> >>
>> >> Machine hangs before starting rc scripts, but SysRq and C-A-Del work.
>> >>
>> >> All tasks are at __schedule+0x268/0x7bc:
>> >>
>> >
>> > .config?
>>
>> Sorry, attached.
>
> Thanks, I swapped disks into my j6700 and will try to reproduce.

It seems the problem is the same as mentioned here:
http://marc.info/?l=linux-kernel&m=123920746830420&w=2

The patch  fixes the issue.

James?
The same problem on two of my hosts: x86_64 with LSI SAS MegaRAID
and parisc with SYM53C8XX_2
