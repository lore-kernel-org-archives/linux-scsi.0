From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sd_many done right (1/5)
Date: Sat, 27 Jul 2002 10:41:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020727104119.A5992@infradead.org>
References: <20020726154533.GD19721@nbkurt.etpnet.phys.tue.nl> <Pine.GSO.4.21.0207261245070.21586-100000@weyl.math.psu.edu> <20020726165411.GI19721@nbkurt.etpnet.phys.tue.nl> <20020726175027.GC2746@clusterfs.com> <20020726185545.B18629@infradead.org> <20020726223224.GJ19721@nbkurt.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020726223224.GJ19721@nbkurt.etpnet.phys.tue.nl>; from garloff@suse.de on Sat, Jul 27, 2002 at 12:32:24AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Alexander Viro <viro@math.psu.edu>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>

On Sat, Jul 27, 2002 at 12:32:24AM +0200, Kurt Garloff wrote:
> But the idea of having a number of majors assigned to disks, no matter what
> the driver below is looks certainly like a good idea. With the current
> approach, we'll need way too many majors, even if we'd have some more bits
> in the future. Why not have a pool of disk majors and sd, hd, dasd, rd
> (DAC960), the IDE-Raids, and ... allocate some of these as needed.

Linus wants this, and he stated that again on the kernel summit.  But to do
this porperly (= not the EVMS way) it needs preparation.  Al currently does
lots of work in that area to make the block drivers largely independent of
the major number.  Once the drivers don't need the major number anymore
internally the only that needs sorting out is userlevel backwards-compatinlity.

I'm pretty sure the preparation will be finished for 2.6, also I can't comment
whether the unified disk major will be done. (Al?)

