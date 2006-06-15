From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Optionally disable QAS in MPT Fusion spi driver
Date: Thu, 15 Jun 2006 16:12:04 +0100
Message-ID: <20060615151204.GA1382@infradead.org>
References: <1149282865.5237.56.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:10913 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030629AbWFOPMJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 11:12:09 -0400
Content-Disposition: inline
In-Reply-To: <1149282865.5237.56.camel@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>

On Fri, Jun 02, 2006 at 03:14:25PM -0600, Andrew Patterson wrote:
> Certain drives report that they support QAS, but it some cases can have
> trouble with it causing bus resets.  This patch optionally disables QAS
> for the MPT Fusion spi driver.  QAS is disabled using the mpt_qas module
> parameter.

I'm not very happy about making this a module paramater in the LLDD as that
can't scale.  This kind of stuff needs to be done in the generic DV code.

