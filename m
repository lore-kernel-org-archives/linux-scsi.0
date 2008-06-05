From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Thu, 5 Jun 2008 06:35:15 -0600
Message-ID: <20080605123515.GM3549@parisc-linux.org>
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

On Thu, Jun 05, 2008 at 12:27:54AM -0600, Andreas Dilger wrote:
> To be honest, however, having the information exported only via sysfs
> is a bit ugly IMHO.  I've had all sorts of grief with settings there
> because there isn't always a match between the device that is being
> specified by the user and what appears in sysfs (e.g. /dev/disk/by-id/foo
> doesn't match /sys/block/sda) and hoops have to be jumped through to
> find this mapping, before parsing a text value in C.

readlink() is too hard?

$ readlink /dev/disk/by-id/ata-FUJITSU_MHV2080AH_NT61T6325UGM
../../hda

> Having an ioctl() that can be called on the block device (getting
> the right device regardless of its name) seems a lot more useful to
> applications in my experience, unless you are using a script.

It's certainly easier.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
