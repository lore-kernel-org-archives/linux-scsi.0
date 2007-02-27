From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: end to end error recovery musings
Date: Tue, 27 Feb 2007 17:51:44 -0500
Message-ID: <yq1mz2z6wov.fsf@sermon.lab.mkp.net>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>
	<yq14pp78rze.fsf@sermon.lab.mkp.net>
	<20070227190236.58323a40@lxorguk.ukuu.org.uk>
	<yq1r6sb7733.fsf@sermon.lab.mkp.net>
	<20070227233946.7ad33a50@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070227233946.7ad33a50@lxorguk.ukuu.org.uk> (alan@lxorguk.ukuu.org.uk's message of "Tue, 27 Feb 2007 23:39:46 +0000")
Sender: linux-raid-owner@vger.kernel.org
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Moore, Eric" <Eric.Moore@lsi.com>, ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Alan" == Alan  <alan@lxorguk.ukuu.org.uk> writes:

>> Not sure you're up-to-date on the T10 data integrity feature.
>> Essentially it's an extension of the 520 byte sectors common in
>> disk

[...]

Alan> but here's a minor bit of passing bad news - quite a few older
Alan> ATA controllers can't issue DMA transfers that are not a
Alan> multiple of 512 bytes without crapping themselves (eg
Alan> READ_LONG). Guess we may need to add
Alan> ap-> i_do_not_suck or similar 8)

I'm afraid it stops even before you get that far.  There doesn't seem
to be any interest in adopting the Data Integrity Feature (or anything
similar) in the ATA camp.  So for now it's a SCSI-only thing.

I encourage people to lean on their favorite disk manufacturer.  This
would be a great feature to have on SATA too...

-- 
Martin K. Petersen	Oracle Linux Engineering

