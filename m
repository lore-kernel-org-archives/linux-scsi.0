From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC/RFT 2/4] add scsi helpers
Date: Thu, 15 Sep 2005 19:29:39 +0100
Message-ID: <20050915182939.GA1316@infradead.org>
References: <1126736388.16778.25.camel@max> <20050915101303.GB24689@infradead.org> <4329AF9F.1030209@cs.wisc.edu> <4329B586.6010802@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:12251 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030566AbVIOS3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 14:29:40 -0400
Content-Disposition: inline
In-Reply-To: <4329B586.6010802@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Thu, Sep 15, 2005 at 12:55:18PM -0500, Mike Christie wrote:
> Actually after talking with Jens, I think it is better to keep the 
> function in scsi_lib and move my blk_rq_map_iov() function there. The 
> problem is that sg and st have some special needs and as a result do 
> some things like partial setup themselves. It looks like nobody wants 
> the burdon of having these special case fucntions :) but since SCSI's 
> ULDs are the only user and probably will be the only user does it make 
> sense to keep them there?

ok, makes sense
