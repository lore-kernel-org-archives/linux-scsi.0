From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: properly count the number of pages in scsi_req_map_sg()
Date: Thu, 23 Mar 2006 14:52:03 +0000
Message-ID: <20060323145203.GA13637@infradead.org>
References: <20060321083830.GA2364@localdomain> <1142956494.4377.12.camel@mulgrave.il.steeleye.com> <20060321161912.GA32051@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44998 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964834AbWCWOwH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Mar 2006 09:52:07 -0500
Content-Disposition: inline
In-Reply-To: <20060321161912.GA32051@localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Aloni <da-x@monatomic.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel List <linux-kernel@vger.kernel.org>, brking@us.ibm.com, dror@xiv.co.il

On Tue, Mar 21, 2006 at 06:19:12PM +0200, Dan Aloni wrote:
> These scatterlists can be generated using the sg driver. Though I am
> actually running a customized version of the sg driver, it seems the 
> conversion from a userspace array of sg_iovec_t to scatterlist stays 
> the same and also applies to the original driver (see 
> st_map_user_pages()).

What kernel version did you reproduce this with?  Since 2.6.16 sg should
obey all request size/alingment limitations.  If not that's a bug in
scsi_execute_async and it's helpers and should be fixed there.
