From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: end to end error recovery musings
Date: Mon, 26 Feb 2007 17:01:18 +0000
Message-ID: <20070226170118.54371f1e@lxorguk.ukuu.org.uk>
References: <45DEF6EF.3020509@emc.com>
	<45DF80C9.5080606@zytor.com>
	<20070224003723.GS10715@schatzie.adilger.int>
	<20070224023229.GB4380@thunk.org>
	<17890.28977.989203.938339@notabene.brown>
	<20070226132511.GB8154@thunk.org>
	<20070226151507.13a1701e@lxorguk.ukuu.org.uk>
	<45E2FA3E.3040201@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45E2FA3E.3040201@emc.com>
Sender: linux-ide-owner@vger.kernel.org
To: ric@emc.com
Cc: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

> I think that this is mostly true, but we also need to balance this against the 
> need for higher levels to get a timely response.  In a really large IO, a naive 
> retry of a very large write could lead to a non-responsive system for a very 
> large time...

And losing the I/O could result in a system that is non responsive until
the tape restore completes two days later....

