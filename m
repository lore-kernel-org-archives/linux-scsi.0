From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: end to end error recovery musings
Date: Wed, 28 Feb 2007 12:42:23 -0500
Message-ID: <yq1hct641s0.fsf@sermon.lab.mkp.net>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>
	<yq14pp78rze.fsf@sermon.lab.mkp.net>
	<20070227190236.58323a40@lxorguk.ukuu.org.uk>
	<yq1r6sb7733.fsf@sermon.lab.mkp.net>
	<20070227233946.7ad33a50@lxorguk.ukuu.org.uk>
	<yq1mz2z6wov.fsf@sermon.lab.mkp.net> <45E587C2.5010209@torque.net>
	<yq1zm6y42z0.fsf@sermon.lab.mkp.net>
	<1172683822.3374.13.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1172683822.3374.13.camel@mulgrave.il.steeleye.com> (James Bottomley's message of "Wed, 28 Feb 2007 11:30:22 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, "Martin K. Petersen" <martin.petersen@oracle.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Moore, Eric" <Eric.Moore@lsi.com>, ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@SteelEye.com> writes:

James> However, I could see the SATA manufacturers selling capacity at
James> 512 (or the new 4096) sectors but allowing their OEMs to
James> reformat them 520 (or 4160)

4104.  It's 8 bytes per hardware sector.  At least for T10...

-- 
Martin K. Petersen	Oracle Linux Engineering
