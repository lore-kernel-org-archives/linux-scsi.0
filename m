From: Christoph Hellwig <hch@infradead.org>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 12:48:11 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227124811.A32109@infradead.org>
References: <1077842444.2662.123.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:7941 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261812AbUB0MsP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 07:48:15 -0500
Content-Disposition: inline
In-Reply-To: <1077842444.2662.123.camel@mulgrave>; from James.Bottomley@steeleye.com on Thu, Feb 26, 2004 at 06:40:43PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Ben Collins <bcollins@debian.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Feb 26, 2004 at 06:40:43PM -0600, James Bottomley wrote:
> I'm forwarding this to linux-scsi, which is the appropriate list to
> scrutinise it.

Well, the last patch looks sane if we want to do that.  But didn't we
declare the mononically increasing host numbers a feature?

