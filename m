From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH 2.6.11-rc2] Linux SCSI hotplug infrastructure
Date: Thu, 14 Apr 2005 20:00:39 +0100
Message-ID: <20050414190039.GA7080@infradead.org>
References: <20050414182433.GA24698@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47751 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261446AbVDNTAj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2005 15:00:39 -0400
Content-Disposition: inline
In-Reply-To: <20050414182433.GA24698@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Apr 14, 2005 at 01:24:33PM -0500, Matt Domsch wrote:
> I posted this back in February, with no response (good or bad).
> I still think this is useful, and would appreciate feedback.

I don't like this at all.  It's adding a kernel roundtrip for things
that should be handled in userland.

