From: Chase Venters <chase.venters@clientec.com>
Subject: Re: memory leak in scsi_cmd_cache 2.6.15
Date: Mon, 23 Jan 2006 00:28:50 -0600
Message-ID: <200601230029.12674.chase.venters@clientec.com>
References: <Pine.LNX.4.62.0601212105590.22868@pureeloreel.qftzy.pbz> <Pine.LNX.4.62.0601222045180.12815@pureeloreel.qftzy.pbz> <1137997104.2977.7.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1137997104.2977.7.camel@laptopd505.fenrus.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ariel <askernel2615@dsgml.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 23 January 2006 00:17, Arjan van de Ven wrote:
> > A commonality I'm noticing is SATA. SATA had a big update in this
> > version, so perhaps that's where to start looking.
>
> I wonder if it can be narrowed even more, like to the exact chipset
> driver?

Anton and I use an Intel 82801 (ICH6). Ariel's dmesg doesn't look like an ICH6 
to me at first glance, but he's also on ata_piix.

Cheers,
Chase
