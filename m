From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: end to end error recovery musings
Date: Wed, 28 Feb 2007 11:30:22 -0600
Message-ID: <1172683822.3374.13.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>
	 <yq14pp78rze.fsf@sermon.lab.mkp.net>
	 <20070227190236.58323a40@lxorguk.ukuu.org.uk>
	 <yq1r6sb7733.fsf@sermon.lab.mkp.net>
	 <20070227233946.7ad33a50@lxorguk.ukuu.org.uk>
	 <yq1mz2z6wov.fsf@sermon.lab.mkp.net> <45E587C2.5010209@torque.net>
	 <yq1zm6y42z0.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <yq1zm6y42z0.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <mkp@mkp.net>
Cc: dougg@torque.net, "Martin K. Petersen" <martin.petersen@oracle.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Moore, Eric" <Eric.Moore@lsi.com>, ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-02-28 at 12:16 -0500, Martin K. Petersen wrote:
> It's cool that it's on the radar in terms of the protocol.  
> 
> That doesn't mean that drive manufacturers are going to implement it,
> though.  The ones I've talked to were unwilling to sacrifice capacity
> because that's the main competitive factor in the SATA/consumer space.
> 
> Maybe we'll see it in the nearline product ranges?  That would be a
> good start...

They wouldn't necessarily have to sacrifice capacity per-se.  The
current problem is that unlike SCSI disks, you can't seem to reformat
SATA ones to arbitrary sector sizes.  However, I could see the SATA
manufacturers selling capacity at 512 (or the new 4096) sectors but
allowing their OEMs to reformat them 520 (or 4160) and then implementing
block guard on top of this.  The OEMs who did this would obviously lose
1.6% of the capacity, but that would be their choice ...

James


