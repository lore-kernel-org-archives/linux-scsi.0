From: Alan Cox <alan@redhat.com>
Subject: Re: PATCH: Further aacraid work
Date: Thu, 17 Jun 2004 16:38:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040617203842.GC8705@devserv.devel.redhat.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2407B@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:29130 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262438AbUFQUlI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 16:41:08 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189FD2407B@otce2k03.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, y@redhat.com
Cc: Alan Cox <alan@redhat.com>, Clay Haapala <chaapala@cisco.com>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Jun 17, 2004 at 01:54:38PM -0400, Salyzyn, Mark wrote:
> And I might add, undoing the entropy to result in the descending page
> list (but that is the forth time I've said this).
> 
> I ran heavy sequential load overnight and continued to have this
> characteristic when taking snapshots of command SG lists. The average SG
> element size statistically was 4168 bytes.

What do the stats look like with the patch Andrew Morton (I think) posted
to reverse the page order from the allocator ?
