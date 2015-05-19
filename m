From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Let's get a File & Storage miniconf going at LPC2015!
Date: Tue, 19 May 2015 08:42:00 -0700
Message-ID: <20150519154200.GA2559@kmo-pixel>
References: <20150515205825.GC24967@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150515205825.GC24967@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 15, 2015 at 01:58:25PM -0700, Darrick J. Wong wrote:
> We of course are not limited to just those topics -- if there's something
> you'd really like to discuss with everyone, please add that to the wiki.
> I realize that mid-August is family vacation time for many people, but
> those are the constraints the conference has to work with this year.
> There are fun things to do around Seattle, and that's probably the best
> time of year to visit.

It's getting near time for the big bcachefs announcement :)

Also, stable pages - what's been going on there? Last I heard you were talking
about using the page migration code to do COW, did anything come of that? I just
added data checksumming/compression to bcachefs, so that's been fresh on my
mind.

Also, there's probably always going to be situations where we're reading or
writing to pages user space can stomp on (dio) - IMO we need to add a bio flag
to annotate this - "if you need this to be stable you have to bounce it".
Otherwise either filesystems/block drivers are going to be stuck bouncing
everything, or it'll just (continue to be) buggy.
