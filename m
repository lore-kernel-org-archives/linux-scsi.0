From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Wed, 29 Mar 2006 10:11:04 +0100
Message-ID: <20060329091104.GB7940@infradead.org>
References: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:1495 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750799AbWC2JL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 04:11:28 -0500
Content-Disposition: inline
In-Reply-To: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: jgarzik@pobox.com, James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Mar 28, 2006 at 04:17:18PM -0600, Brian King wrote:
> 
> Add a max_cmd_len field to the scsi_device struct
> to allow for per device limits of allowable command
> lengths. This will be used by libata, which is currently
> using the max_cmd_len field in the scsi_host struct,
> which doesn't work for attaching libata controlled
> SATA devices to SAS HBAs.

this sounds wrong to me.  cdb length is a limitation of the host (driver).
A target will reject unknown commands, no matter what length they have.

