From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: end to end error recovery musings
Date: Wed, 28 Feb 2007 12:16:35 -0500
Message-ID: <yq1zm6y42z0.fsf@sermon.lab.mkp.net>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>
	<yq14pp78rze.fsf@sermon.lab.mkp.net>
	<20070227190236.58323a40@lxorguk.ukuu.org.uk>
	<yq1r6sb7733.fsf@sermon.lab.mkp.net>
	<20070227233946.7ad33a50@lxorguk.ukuu.org.uk>
	<yq1mz2z6wov.fsf@sermon.lab.mkp.net> <45E587C2.5010209@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <45E587C2.5010209@torque.net> (Douglas Gilbert's message of "Wed, 28 Feb 2007 08:46:42 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: dougg@torque.net
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Moore, Eric" <Eric.Moore@lsi.com>, ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dougg@torque.net> writes:

Doug> Work on SAT-2 is now underway and one of the agenda items is
Doug> "end to end data protection" and is in the hands of the t13
Doug> ATA8-ACS technical editor. So it looks like data integrity is on
Doug> the radar in the SATA world.

It's cool that it's on the radar in terms of the protocol.  

That doesn't mean that drive manufacturers are going to implement it,
though.  The ones I've talked to were unwilling to sacrifice capacity
because that's the main competitive factor in the SATA/consumer space.

Maybe we'll see it in the nearline product ranges?  That would be a
good start...

-- 
Martin K. Petersen      http://mkp.net/

