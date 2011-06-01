From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 10/42] target: Rewrite transport_init_task_sg()
Date: Tue, 31 May 2011 17:33:59 -0700
Message-ID: <1306888439.8193.382.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306523240-15543-11-git-send-email-agrover@redhat.com>
	 <1306825729.8193.77.camel@haakon2.linux-iscsi.org>
	 <4DE557F4.3080700@redhat.com>  <20110531210825.GA17340@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54237 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758469Ab1FAAmX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 20:42:23 -0400
In-Reply-To: <20110531210825.GA17340@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andy Grover <agrover@redhat.com>, linux-iscsi-target-dev@googlegroups.com, target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-05-31 at 17:08 -0400, Christoph Hellwig wrote:
> On Tue, May 31, 2011 at 02:04:52PM -0700, Andy Grover wrote:
> > Every sg[] that is initialized by sg_init_table (or sg_init_one) should
> > have sg_mark_end called on its last element[1] so I think we're ok, or
> > am I misunderstanding the issue you're getting at?
> 
> No, you understand it right.  That's how chained S/G lists are supposed
> to work.
> 

Ok, thanks for the clarification here guys.  I am going take a little
extra time for reviewing and testing these on existing HW target mode
code, and will plan to push for tomorrow if everything looks OK.

Thanks!

--nab

