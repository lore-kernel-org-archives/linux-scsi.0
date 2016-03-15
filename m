From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: disable automatic target scan
Date: Tue, 15 Mar 2016 07:48:37 +0100
Message-ID: <20160315064837.GA9879@lst.de>
References: <1457710420-37769-1-git-send-email-hare@suse.de> <yq1y49kfwa9.fsf@sermon.lab.mkp.net> <56E7B006.6020809@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44669 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbcCOGsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 02:48:39 -0400
Content-Disposition: inline
In-Reply-To: <56E7B006.6020809@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Tue, Mar 15, 2016 at 07:47:34AM +0100, Hannes Reinecke wrote:
> > So "disabled" is "sometimes enabled" and "none" is "really disabled"?
> >  
> 'disabled' means:
> disable automatic scanning, but allow manual scanning via the 'scan'
> attribute.

maybe rename disabled to manual?  And improve the modoule parameter
description while we're at it.
