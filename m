From: Ariel <askernel2615@dsgml.com>
Subject: Re: memory leak in scsi_cmd_cache 2.6.15
Date: Sun, 22 Jan 2006 21:19:40 -0500 (EST)
Message-ID: <Pine.LNX.4.62.0601222115440.12815@pureeloreel.qftzy.pbz>
References: <Pine.LNX.4.62.0601212105590.22868@pureeloreel.qftzy.pbz>
 <200601221317.17124.chase.venters@clientec.com> <1137957890.3328.41.camel@laptopd505.fenrus.org>
 <200601221346.25154.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200601221346.25154.chase.venters@clientec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Chase Venters <chase.venters@clientec.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 22 Jan 2006, Chase Venters wrote:

> We did determine that Anton and I both use the Marvell sk98lin patch for our
> Yukon2s. However, Anton reported other servers using this patch with no leak.
>
> Ariel - are you using sk98lin? The only other modules I'm using are the ALSA
> modules for snd-hda-intel as of ALSA version 1.0.11-rc2.

Not that I know of. I'm using the kernel from debian unstable, so it's 
whatever patches they use: 
http://svn.debian.org/wsvn/kernel/releases/linux-2.6/2.6.15-2/debian/patches/?rev=0&sc=0

Are you using SATA?

 	-Ariel
