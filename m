From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] make some sas class properties optional
Date: Fri, 3 Mar 2006 11:41:44 +0000
Message-ID: <20060303114144.GA20044@infradead.org>
References: <1141336891.3238.68.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50112 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751233AbWCCLls (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 06:41:48 -0500
Content-Disposition: inline
In-Reply-To: <1141336891.3238.68.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Mar 02, 2006 at 04:01:31PM -0600, James Bottomley wrote:
> aic94xx doesn't have a use for the bay or enclosure identifiers.
> Also, I think it's not going to need a get_linkerrors(), so wire up
> all of these exported properties as conditional on the underlying
> function support.

Making these optional is okay.

the expander identifier is part of the SMP REPORT_GENERAL reply, so aic94xx
should be able to support it easily.  Similarly I'm pretty sure it supports
link error statistics aswell.

