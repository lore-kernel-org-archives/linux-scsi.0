From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sd_many done right (1/5)
Date: Fri, 26 Jul 2002 18:55:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <11807.3539379568$1027706558@news.gmane.org>
References: <20020726154533.GD19721@nbkurt.etpnet.phys.tue.nl> <Pine.GSO.4.21.0207261245070.21586-100000@weyl.math.psu.edu> <20020726165411.GI19721@nbkurt.etpnet.phys.tue.nl> <20020726175027.GC2746@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020726175027.GC2746@clusterfs.com>; from adilger@clusterfs.com on Fri, Jul 26, 2002 at 11:50:27AM -0600
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Alexander Viro <viro@math.psu.edu>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>, Marcelo Tosatti <marcelo@conectiva.com.br>

On Fri, Jul 26, 2002 at 11:50:27AM -0600, Andreas Dilger wrote:
> Actually, one interesting aspect of the EVMS vs. device-mapper argument
> going on that has totally been missed is that EVMS can do management of
> ALL disk block devices.

That's only natural as it try to duplicate the whole Linux block layer.
But it's everything but a good idea.

