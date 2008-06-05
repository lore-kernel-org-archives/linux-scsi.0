From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Thu, 5 Jun 2008 11:32:24 +0100
Message-ID: <20080605103224.GA20308@shareable.org>
References: <patchbomb.1212643369@sermon.lab.mkp.net> <20080605062754.GQ2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080605062754.GQ2961@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andreas Dilger wrote:
> Having an ioctl() that can be called on the block device (getting
> the right device regardless of its name) seems a lot more useful to
> applications in my experience, unless you are using a script.

I agree with this - ioctl() on actual block devices is more direct,
and the quirks needed to get the right sysfs dir awkward.

It would be good to use the same ioctl() as other OSes if there are
any exporting the same information.

However, sysfs, being text based, is easier to extend with new values
that can be used without recompiling programs, e.g. from scripts, so
it's useful to have the same information there.

To link them, an ioctl() which returns an unambiguous reference to the
appropriate sysfs entry would be good too.  E.g. perhaps returning a
file descriptor of the appropriate directory.

-- Jamie
