From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fwd: 32bit dev_t
Date: Mon, 27 Jan 2003 22:51:25 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030127225125.A13617@infradead.org>
References: <3E2DC21D.9010204@torque.net> <20030123183131.GA2126@nbkurt.garloff.de> <20030123221805.A2468@infradead.org> <20030124182952.GF20972@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030124182952.GF20972@ca-server1.us.oracle.com>; from Joel.Becker@oracle.com on Fri, Jan 24, 2003 at 10:29:53AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Kurt Garloff <kurt@garloff.de>, Douglas Gilbert <dougg@torque.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Fri, Jan 24, 2003 at 10:29:53AM -0800, Joel Becker wrote:
> 	How are they allocated?  Is this dynamic, or compiled in?  In
> addition, what is the maximum amount?  If it's less than 1000 disks,
> it's too small for today.  If it's less than 2000 disks, it's probably
> too small for 2.6's lifetime.

Currently it's compiled in, and the trivial change to make it use
register_blkdev with a 0 major argument until all globally unused majors
are gone is left to the reader..
