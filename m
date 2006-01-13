From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/10] iscsi: add high mem support
Date: Fri, 13 Jan 2006 18:16:05 +0000
Message-ID: <20060113181605.GN20718@infradead.org>
References: <1137128916.9508.38.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9178 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422789AbWAMSQG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:16:06 -0500
Content-Disposition: inline
In-Reply-To: <1137128916.9508.38.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

I'm not too happy with this one, but given that we can't get to an agreement
to disallow sending down kmalloced patches we'll need this patch.
