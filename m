From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: Pb between an UltraTrak SX8000 and an Adaptec 29160
Date: Wed, 20 Nov 2002 10:35:52 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0211201023480.22001-100000@router.windsormachine.com>
References: <3DDBA8A8.F370532E@lipsyncpost.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DDBA8A8.F370532E@lipsyncpost.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Simon Burley <simonb@lipsyncpost.co.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, didier@ece.gatech.edu, "'Justin T. Gibbs'" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

On Wed, 20 Nov 2002, Simon Burley wrote:

> > Linux 2.4.x doesnt support single volumes over 1Tb. Thats fixed in 2.5
>
> Can I ask what the symptoms of this failure to support >1Tb volumes
> would be? Failure to identify the device? Random read/write failures?
> Completely corrupted disk? It's the first time I've heard this!
>

What about the software raid /dev/md0?

I remember vaguely about the group that was doing raid5 on 75 gig IBM
Deathstars(can't remember url) having issues with terrabyte volumes, and
doing a pair of half terrabytes instead.

The article is so old and out of date though

www.nobell.org/~gjm/linux/ide-raid/

Speaking of deathstars:

www-cdf.final.gov/offline/warnings.html

Note about deathstars, and about 3ware and WD drives. =)

Mike


