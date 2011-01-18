From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] target: remove EXTRA_CFLAGS
Date: Tue, 18 Jan 2011 22:20:43 +0100
Message-ID: <20110118212043.GA12597@lst.de>
References: <20110118202434.GA10884@lst.de> <20110118202458.GB10884@lst.de> <1295384356.22813.442.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:40288 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1ARVUr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 16:20:47 -0500
Content-Disposition: inline
In-Reply-To: <1295384356.22813.442.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 18, 2011 at 12:59:16PM -0800, Nicholas A. Bellinger wrote:
> On Tue, 2011-01-18 at 21:24 +0100, Christoph Hellwig wrote:
> > Add the current directory is superflous in general, and no includes in
> > drivers/scsi are needed either.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> Committed as c524eda into lio-core-2.6.git and picked into
> scsi-post-merge-2.6.git/for-jejb.

tcm_mod_builder.py should get a similar treatment, but I'm not python
savy enough to not fuck that up.
