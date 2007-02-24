From: Chris Wedgwood <cw@f00f.org>
Subject: Re: end to end error recovery musings
Date: Sat, 24 Feb 2007 10:39:15 -0800
Message-ID: <20070224183915.GB13940@tuatara.stupidest.org>
References: <45DEF6EF.3020509@emc.com> <45DF80C9.5080606@zytor.com> <20070224003723.GS10715@schatzie.adilger.int> <20070224023229.GB4380@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070224023229.GB4380@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>, Ric Wheeler <ric@emc.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Neil Brown <neilb@suse.de>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 23, 2007 at 09:32:29PM -0500, Theodore Tso wrote:

> And having a way of making this list available to both the
> filesystem and to a userspace utility, so they can more easily deal
> with doing a forced rewrite of the bad sector, after determining
> which file is involved and perhaps doing something intelligent (up
> to and including automatically requesting a backup system to fetch a
> backup version of the file, and if it can be determined that the
> file shouldn't have been changed since the last backup,
> automatically fixing up the corrupted data block :-).

i had a small c program + perl script that would take a badblocks list
and figure out which files on an xfs filesystem were trashed, though
in the case of xfs it's somewhat easier because you can dump the
extents for a file something more generic wouldn't be hard to make
work, it also wouldn't be hard to extend this to inodes in some cases
though im not sure that there is much you can do there beyond fsck

