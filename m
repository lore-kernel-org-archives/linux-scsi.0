From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: end to end error recovery musings
Date: Tue, 27 Feb 2007 23:39:46 +0000
Message-ID: <20070227233946.7ad33a50@lxorguk.ukuu.org.uk>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>
	<yq14pp78rze.fsf@sermon.lab.mkp.net>
	<20070227190236.58323a40@lxorguk.ukuu.org.uk>
	<yq1r6sb7733.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1r6sb7733.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Moore, Eric" <Eric.Moore@lsi.com>, ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

> Not sure you're up-to-date on the T10 data integrity feature.
> Essentially it's an extension of the 520 byte sectors common in disk

I saw the basics but not the detail. Thanks for the explanation it was
most helpful and promises to fix a few things for some controllers.. but
here's a minor bit of passing bad news - quite a few older ATA controllers
can't issue DMA transfers that are not a multiple of 512 bytes without
crapping themselves (eg READ_LONG). Guess we may need to add
ap->i_do_not_suck or similar 8)

On the bright side I believe the Intel ICH is the only one with this
problem (and a workaround) which is SATA capable 8)

Alan
