From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/2] fusion SAS support
Date: Wed, 24 Aug 2005 10:57:56 +0200
Message-ID: <20050824085756.GA11691@lst.de>
References: <20050819162634.GA15401@lst.de> <20050824070840.GA568604@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:59803 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1750763AbVHXI6H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 04:58:07 -0400
Content-Disposition: inline
In-Reply-To: <20050824070840.GA568604@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: jejb@steeleye.com, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

On Wed, Aug 24, 2005 at 12:08:40AM -0700, Jeremy Higdon wrote:
> Hi Christoph,
> 
> I applied your four (sets of) patches, and they all seem to work
> fine.  When connected through an expander, the data is a little light,
> but direct connect works great.  Below, targets 0 and 1 are direct
> connect to a 1064 chip, while targets 21-29 are through an expander.

The device_type = none for the target connected through the expander
looks wrong.  I'll hopefully have an enclosure with an expander soon
and will fix this.
