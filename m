From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: move entirely over to correct transport class
	formulation
Date: Tue, 28 Mar 2006 09:13:53 -0600
Message-ID: <1143558834.3353.10.camel@mulgrave.il.steeleye.com>
References: <1143499534.3334.33.camel@mulgrave.il.steeleye.com>
	 <20060328150709.GA17420@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:43755 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751016AbWC1PN6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 10:13:58 -0500
In-Reply-To: <20060328150709.GA17420@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-03-28 at 16:07 +0100, Christoph Hellwig wrote:
> Adding an own transport class for aic94xx seems very wrong.  It should
> attach to the standard sas one and use the sas-class based code as
> some kind of libsas.

It's not an own transport class.  It's dependent on the sas transport
class.  The difficulty was where to put the interface functions,
particularly as some of the sas transport class interface functions are
implemented in the sas domain library.  In the end, it seems best to
attach it like a transport class, but have it effectively pass through
the attachment to the sas transport class.

James


