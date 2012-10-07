From: Christoph Hellwig <hch@infradead.org>
Subject: Re: standards revisions
Date: Sun, 7 Oct 2012 10:51:54 -0400
Message-ID: <20121007145154.GA30586@infradead.org>
References: <20121007014900.GA30316@infradead.org>
 <1349590310.9312.163.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58799
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab2JGOwA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Oct 2012 10:52:00 -0400
Content-Disposition: inline
In-Reply-To: <1349590310.9312.163.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Roland Dreier <roland@kernel.org>

On Sat, Oct 06, 2012 at 11:11:50PM -0700, Nicholas A. Bellinger wrote:
> On Sat, 2012-10-06 at 21:49 -0400, Christoph Hellwig wrote:
> > Currenly all non-pscsi bakcneds report their standards version as
> > SPC 2 via ->get_device_rev.
> 
> No, the proper on-the-wire bits to signal SPC-3 compliance are already
> being returned by virtual backend drivers within standard INQUIRY
> payload data.  

I missed that, but it doesn't matter for the point I was making, which
is the code to special case the SCSI_2 case, which can't happen for
any virtual backend.  In addition it also can't happen for pscsi as
we don't wire up any command emulation but REPORT LUNS for it any more,
effectively making it dead code.

