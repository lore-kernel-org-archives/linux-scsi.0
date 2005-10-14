From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 11/12] qla2xxx: Add an 'Issue LIP' device attribute.
Date: Fri, 14 Oct 2005 15:44:53 -0700
Message-ID: <20051014224453.GD28524@plap.qlogic.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231724.27191.33356.sendpatchset@plap.qlogic.com> <20051014094843.GB22347@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:51028 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1750999AbVJNWoy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 18:44:54 -0400
Content-Disposition: inline
In-Reply-To: <20051014094843.GB22347@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 14 Oct 2005, Christoph Hellwig wrote:

> On Thu, Oct 13, 2005 at 04:17:24PM -0700, Andrew Vasquez wrote:
> > Subject: Add an 'Issue LIP' device attribute.
> > 
> > Add a scsi_host device attribute to allow a user to initiate
> > a LIP.
> 
> This kind of thing belongs into the transport class so that we have
> a common API over all HBA drivers.

Makes sense.  I'll get something posted on Monday.

Thanks,
Andrew
