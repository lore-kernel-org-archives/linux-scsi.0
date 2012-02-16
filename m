From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 07/13] target: Inline struct se_tmr_req into se_cmd
Date: Wed, 15 Feb 2012 16:05:33 -0800
Message-ID: <1329350733.5093.128.camel@haakon2.linux-iscsi.org>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
	 <1327009163-10177-8-git-send-email-agrover@redhat.com>
	 <20120120161209.GA22481@infradead.org>  <4F19A80B.6000902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50177 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab2BPAFg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2012 19:05:36 -0500
In-Reply-To: <4F19A80B.6000902@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, kiran.patil@intel.com

On Fri, 2012-01-20 at 09:44 -0800, Andy Grover wrote:
> On 01/20/2012 08:12 AM, Christoph Hellwig wrote:
> > On Thu, Jan 19, 2012 at 01:39:17PM -0800, Andy Grover wrote:
> >> This saves all fabrics from calling core_tmr_alloc_req() and
> >> having to check the result. The downside is se_cmd gets bigger for all
> >> requests, but hopefully later patches will reduce it.
> > 
> > Without patches to void the overhead it's not acceptable. Fortunately
> > it should be doable fairly simply by using an union for command vs
> > TMR fields.
> 
> This was my thought too. We should be able to move cmd variables into a
> union w/tmr struct very soon, with a low risk of introducing bugs.
> 

Hi Andy,

Ping on this..?  I've been merging patches from lio-core into
target-pending/for-next the past week, and i've stopped ahead of this
patch to inline se_tmr_req into se_cmd due of the extra overhead in
question here..

I'd really like to get this resolved in v3.4 for-next, so would you mind
taking care of the lio-core conversion to union for command vs
TMR fields so this can be squashed into for-next..?

Thanks,

--nab





