From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/12] qla2xxx: Add an 'Issue LIP' device attribute.
Date: Fri, 28 Oct 2005 23:53:21 +0100
Message-ID: <20051028225321.GB13958@infradead.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231724.27191.33356.sendpatchset@plap.qlogic.com> <20051014094843.GB22347@infradead.org> <20051027230337.GE7889@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55500 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030307AbVJ1WxX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 18:53:23 -0400
Content-Disposition: inline
In-Reply-To: <20051027230337.GE7889@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>

On Thu, Oct 27, 2005 at 04:03:37PM -0700, Andrew Vasquez wrote:
> Ok, here's a patch to add such a common API for fc transport users.
> Relevant LLD changes (lpfc and qla2xxx) also present.
> 
> Reasonable?

Looks good, thanks.

And sorry for not noticing that lpfc sneaked it in already, otherwise
I would have made Emulex do this :)

