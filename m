From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Fw: PROBLEM: Linux V. 2.6.3 panics with "Buffers at physical address >16Mb used for aha1542" at boot time
Date: Fri, 20 Feb 2004 09:52:02 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040220175202.GA898@beaverton.ibm.com>
References: <20040218171212.0eb6618a.akpm@osdl.org> <1077243517.2164.61.camel@mulgrave> <1077265837.1297.9.camel@felicia> <1077295765.1937.0.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:44277 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261349AbUBTRqk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Feb 2004 12:46:40 -0500
Content-Disposition: inline
In-Reply-To: <1077295765.1937.0.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Dr. Ernst Molitor" <molitor@uni-bonn.de>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Fri, 2004-02-20 at 00:30, Dr. Ernst Molitor wrote:
> > Please don't hesitate to contact me if I can be of any further help in
> > this matter.
> 
> The problem seems to be a non-GFP_DMA allocation in sr.c.  Could you try
> this patch?
> 
> Thanks,
> 

What about the buffer off the stack that cdrom_is_mrw uses? cgc->buffer
is set to this stack buffer which is used directly in sr_do_ioctl when
scsi_wait_req is called.

-andmike
--
Michael Anderson
andmike@us.ibm.com

