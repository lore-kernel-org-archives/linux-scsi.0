From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] libsas: disable scanning lun > 0 on ata devices
Date: Tue, 20 Sep 2011 18:15:54 -0400
Message-ID: <20110920221554.GA2530@infradead.org>
References: <20110920220819.1094.12265.stgit@localhost6.localdomain6>
 <20110920221008.1094.34064.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40477
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026Ab1ITWQf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2011 18:16:35 -0400
Content-Disposition: inline
In-Reply-To: <20110920221008.1094.34064.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Luben Tuikov <ltuikov@yahoo.com>, jgarzik@pobox.com, JBottomley@parallels.com, Jack Wang <jack_wang@usish.com>, Xiangliang Yu <yuxiangl@marvell.com>, Mark Salyzyn <msalyzyn@us.xyratex.com>, Darrick Wong <djwong@us.ibm.com>

On Tue, Sep 20, 2011 at 03:10:19PM -0700, Dan Williams wrote:
> Currently mvsas and pm8001 have custom ->slave_alloc implementations to
> achieve this.  Uplevel it for all libsas drivers as isci encounters problems
> with atapi devices when scanning past lun0.
> 
> Just do what Darrick suggested [1], and limit the scan for ata devices.
> 
> [1] http://marc.info/?l=linux-scsi&m=116604101119861&w=2

Looks reasonable.

