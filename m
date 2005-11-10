From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/10] remove scsi_request usage from sg and st
Date: Thu, 10 Nov 2005 13:02:45 +0000
Message-ID: <20051110130245.GA11364@infradead.org>
References: <1131444389.23111.56.camel@max> <20051110105513.GA9118@infradead.org> <43734249.3030800@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35037 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750830AbVKJNCw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 08:02:52 -0500
Content-Disposition: inline
In-Reply-To: <43734249.3030800@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@suse.de, linux-scsi@vger.kernel.org

On Thu, Nov 10, 2005 at 06:51:21AM -0600, Mike Christie wrote:
> Oh yeah was my last max_sectors close
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113147482216587&w=2
> or did it need work, or do I just need to get LLD writers to set their 
> sht->max_sectors correctly?

Looks good to me.
