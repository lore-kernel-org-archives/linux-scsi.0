From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] fusion SAS support
Date: Wed, 24 Aug 2005 10:14:24 +0100
Message-ID: <20050824091424.GC26447@infradead.org>
References: <20050819162634.GA15401@lst.de> <20050824070840.GA568604@sgi.com> <20050824085756.GA11691@lst.de> <20050824091014.GA569688@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10213 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750808AbVHXJO2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 05:14:28 -0400
Content-Disposition: inline
In-Reply-To: <20050824091014.GA569688@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: jejb@steeleye.com, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

On Wed, Aug 24, 2005 at 02:10:14AM -0700, Jeremy Higdon wrote:
> However, after updating firmware on the 1064, this latter problem
> seems to be fixed (still doesn't discover devices on the expander
> at driver init).

As mentioned expanders aren't tested at all yet, I'll fix it as soon
as I have an expander and hopefully soon the fusion specs (still waiting
for lsi to contact me about the nda)

