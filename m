From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/42] target: Rewrite transport_init_task_sg()
Date: Tue, 31 May 2011 17:08:25 -0400
Message-ID: <20110531210825.GA17340@infradead.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
 <1306523240-15543-11-git-send-email-agrover@redhat.com>
 <1306825729.8193.77.camel@haakon2.linux-iscsi.org>
 <4DE557F4.3080700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42525
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932482Ab1EaVIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 17:08:31 -0400
Content-Disposition: inline
In-Reply-To: <4DE557F4.3080700@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, May 31, 2011 at 02:04:52PM -0700, Andy Grover wrote:
> Every sg[] that is initialized by sg_init_table (or sg_init_one) should
> have sg_mark_end called on its last element[1] so I think we're ok, or
> am I misunderstanding the issue you're getting at?

No, you understand it right.  That's how chained S/G lists are supposed
to work.

