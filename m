From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fwd: 32bit dev_t
Date: Tue, 28 Jan 2003 11:28:40 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030128112840.A27734@infradead.org>
References: <3E2DC21D.9010204@torque.net> <20030123183131.GA2126@nbkurt.garloff.de> <20030123221805.A2468@infradead.org> <20030124182952.GF20972@ca-server1.us.oracle.com> <20030127225125.A13617@infradead.org> <1043752867.1328.10.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1043752867.1328.10.camel@dhcp22.swansea.linux.org.uk>; from alan@lxorguk.ukuu.org.uk on Tue, Jan 28, 2003 at 11:21:07AM +0000
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Joel Becker <Joel.Becker@oracle.com>, Kurt Garloff <kurt@garloff.de>, Douglas Gilbert <dougg@torque.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Tue, Jan 28, 2003 at 11:21:07AM +0000, Alan Cox wrote:
> On Mon, 2003-01-27 at 22:51, Christoph Hellwig wrote:
> > Currently it's compiled in, and the trivial change to make it use
> > register_blkdev with a 0 major argument until all globally unused majors
> > are gone is left to the reader..
> 
> Which leaves the non trivial change of figuring out a usable security
> model when doing that. I've yet to see one

That's why I didn't implement it.  Ask the SuSE folks, they already ship
the dynamic majors for sd hack in their 2.4-based tree.

