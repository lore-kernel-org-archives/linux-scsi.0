From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi-driver ultrastore replace Scsi_Cmnd with struct scsi_cmnd
Date: Mon, 18 Sep 2006 19:53:21 +0100
Message-ID: <20060918185321.GB17670@infradead.org>
References: <44FE8BAC.1030004@nachtwindheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54980 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932093AbWIRSxr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 14:53:47 -0400
Content-Disposition: inline
In-Reply-To: <44FE8BAC.1030004@nachtwindheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Henne <henne@nachtwindheim.de>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Sep 06, 2006 at 10:49:48AM +0200, Henne wrote:
> From: Henrik Kretzschmar <henne@nachtwindheim.de>
> 
> Replaces the typedef'd Scsi_Cmnd with struct scsi_cmnd.
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

Looks good to me.  It would be even better if you could update the
driver to not require

	#include "scsi.h"

anymore and get rid of ultrastor.h.  Also your mailer unfortunately
damages tabs.

