From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch 6/7] megaraid_sas: adds tasklet for cmd completion
Date: Thu, 21 Sep 2006 12:46:12 +0100
Message-ID: <20060921114612.GB30858@infradead.org>
References: <1158805889.4171.66.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10936 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751104AbWIULqd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Sep 2006 07:46:33 -0400
Content-Disposition: inline
In-Reply-To: <1158805889.4171.66.camel@dumbo>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumant Patro <sumantp@lsil.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, akpm@osdl.org, hch@lst.de, linux-kernel@vger.kernel.org, Neela.Kolli@lsil.com, Bo.Yang@lsil.com

On Wed, Sep 20, 2006 at 07:31:29PM -0700, Sumant Patro wrote:
> This patch adds a tasklet for command completion.

Why would you need this?  The normal scsi command completion is offloaded
to the SCSI softirq ASAP so I don't see any point for those.  Do you see
too much time spent in completion of the internal commands?

