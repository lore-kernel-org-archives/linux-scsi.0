From: Jens Axboe <axboe@suse.de>
Subject: Re: [RFC] [PATCH 2.6.9-rc1] add blacklist attribute indicating no ULD attach
Date: Wed, 15 Sep 2004 09:40:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915074032.GN2304@suse.de>
References: <20040914063237.GA97486@sgi.com> <20040914144023.GA9524@beaverton.ibm.com> <20040914182203.GA100433@sgi.com> <20040915031834.GA102988@sgi.com> <20040915074744.A17264@infradead.org> <20040915073757.GA102330@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:15301 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262605AbUIOHmO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 03:42:14 -0400
Content-Disposition: inline
In-Reply-To: <20040915073757.GA102330@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, patmans@us.ibm.com, james.bottomley@steeleye.com

On Wed, Sep 15 2004, Jeremy Higdon wrote:
> On Wed, Sep 15, 2004 at 07:47:44AM +0100, Christoph Hellwig wrote:
> > On Tue, Sep 14, 2004 at 08:18:34PM -0700, Jeremy Higdon wrote:
> > >  	}
> > > +	else if (*bflags & BLIST_NO_ULD_ATTACH) {
> > 
> > Please put the else if on the same line as the closing brace
> 
> I don't like that style, but it does seem to be specified (I
> hadn't noticed before) . . .

Well if we are going to be picky, you should not be using braces for
this single-line case at all :-)

-- 
Jens Axboe

