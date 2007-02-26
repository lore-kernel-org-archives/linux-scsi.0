From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: end to end error recovery musings
Date: Mon, 26 Feb 2007 09:17:19 -0600
Message-ID: <1172503039.3344.4.camel@mulgrave.il.steeleye.com>
References: <45DEF6EF.3020509@emc.com> <45DF80C9.5080606@zytor.com>
	 <20070224003723.GS10715@schatzie.adilger.int>
	 <20070224023229.GB4380@thunk.org>
	 <17890.28977.989203.938339@notabene.brown>
	 <20070226132511.GB8154@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070226132511.GB8154@thunk.org>
Sender: linux-ide-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Ric Wheeler <ric@emc.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2007-02-26 at 08:25 -0500, Theodore Tso wrote:
> Somewhat off-topic, but my one big regret with how the dm vs. evms
> competition settled out was that evms had the ability to perform block
> device snapshots using a non-LVM volume as the base --- and that EVMS
> allowed a single drive to be partially managed by the LVM layer, and
> partially managed by evms.  

If all you want is a snapshot, md can do this today ... you just create
a RAID-1 resync it and then break it ... of course, you have to have the
filesystem mounted above an md device initially ...

James


