From: Alexander Viro <viro@math.psu.edu>
Subject: Re: [PATCH] sd_many done right (1/5)
Date: Fri, 26 Jul 2002 12:45:41 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0207261245070.21586-100000@weyl.math.psu.edu>
References: <20020726154533.GD19721@nbkurt.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020726154533.GD19721@nbkurt.etpnet.phys.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>, Marcelo Tosatti <marcelo@conectiva.com.br>



On Fri, 26 Jul 2002, Kurt Garloff wrote:

> Hi,
> 
> here comes patch 1/5 from a series of patches to support more than 128 (and
> optionally more than 256) SCSI disks with Linux 2.4 by changing the sd driver
> to dynamically allocate memory and register block majors as disks get
> attached.
> 
> The patches are all available at
> http://www.suse.de/~garloff/linux/scsi-many/

As long as you realize that it won't go in 2.5 in that form...

