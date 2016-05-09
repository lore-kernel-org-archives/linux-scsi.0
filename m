From: Paul Mackerras <paulus@ozlabs.org>
Subject: Re: [PATCH] scsi_dh_alua: do not fail for unknown VPD identification
Date: Mon, 9 May 2016 13:34:47 +1000
Message-ID: <20160509033447.GA12515@fergus.ozlabs.ibm.com>
References: <1462523675-63172-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:52640 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbcEIDhw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 May 2016 23:37:52 -0400
Content-Disposition: inline
In-Reply-To: <1462523675-63172-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, May 06, 2016 at 10:34:35AM +0200, Hannes Reinecke wrote:
> Not every device will return a useable VPD identification, but
> still might support ALUA. Rather then disable ALUA support we
> should be allowing the device identification to be empty and
> attach individual ALUA device handler to each devices.
> 
> Reported-by: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Tested-by: Paul Mackerras <paulus@ozlabs.org>
