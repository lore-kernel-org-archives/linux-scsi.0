From: Ariel <askernel2615@dsgml.com>
Subject: Re: memory leak in scsi_cmd_cache 2.6.15
Date: Mon, 23 Jan 2006 01:46:13 -0500 (EST)
Message-ID: <Pine.LNX.4.62.0601230136080.22979@pureeloreel.qftzy.pbz>
References: <Pine.LNX.4.62.0601212105590.22868@pureeloreel.qftzy.pbz>
 <Pine.LNX.4.62.0601222045180.12815@pureeloreel.qftzy.pbz>
 <1137997104.2977.7.camel@laptopd505.fenrus.org> <200601230029.12674.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200601230029.12674.chase.venters@clientec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Chase Venters <chase.venters@clientec.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Jamie Heilman <jamie@audible.transient.net>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 23 Jan 2006, Chase Venters wrote:

> On Monday 23 January 2006 00:17, Arjan van de Ven wrote:
>>> A commonality I'm noticing is SATA. SATA had a big update in this
>>> version, so perhaps that's where to start looking.
>>
>> I wonder if it can be narrowed even more, like to the exact chipset
>> driver?
>
> Anton and I use an Intel 82801 (ICH6). Ariel's dmesg doesn't look like an ICH6
> to me at first glance, but he's also on ata_piix.

I'm on ICH5, but also Sil3112 and HighPoint 372N.

Jamie has ICH6 and Sil3112.

ata_piix seems like it's in common for all, but this is not a lot of 
systems, so it could just be a coincidence and the problem caused by 
something that's not chipset specific.

 	-Ariel
