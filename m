From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/12] qla2xxx: Add an 'Issue LIP' device attribute.
Date: Fri, 14 Oct 2005 10:48:43 +0100
Message-ID: <20051014094843.GB22347@infradead.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231724.27191.33356.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:13029 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751388AbVJNJsr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 05:48:47 -0400
Content-Disposition: inline
In-Reply-To: <20051013231724.27191.33356.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Oct 13, 2005 at 04:17:24PM -0700, Andrew Vasquez wrote:
> Subject: Add an 'Issue LIP' device attribute.
> 
> Add a scsi_host device attribute to allow a user to initiate
> a LIP.

This kind of thing belongs into the transport class so that we have
a common API over all HBA drivers.

