From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/13] target: Inline struct se_tmr_req into se_cmd
Date: Fri, 20 Jan 2012 11:12:09 -0500
Message-ID: <20120120161209.GA22481@infradead.org>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
 <1327009163-10177-8-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60239
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753990Ab2ATQMM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2012 11:12:12 -0500
Content-Disposition: inline
In-Reply-To: <1327009163-10177-8-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, kiran.patil@intel.com

On Thu, Jan 19, 2012 at 01:39:17PM -0800, Andy Grover wrote:
> This saves all fabrics from calling core_tmr_alloc_req() and
> having to check the result. The downside is se_cmd gets bigger for all
> requests, but hopefully later patches will reduce it.

Without patches to void the overhead it's not acceptable. Fortunately
it should be doable fairly simply by using an union for command vs
TMR fields.

