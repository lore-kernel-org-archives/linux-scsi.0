From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aha1740 update
Date: Thu, 3 Jul 2003 16:13:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030703161335.A4558@infradead.org>
References: <wrp7k72ktkg.fsf@hina.wild-wind.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:18191 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264030AbTGCO7M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2003 10:59:12 -0400
Content-Disposition: inline
In-Reply-To: <wrp7k72ktkg.fsf@hina.wild-wind.fr.eu.org>; from mzyngier@freesurf.fr on Tue, Jul 01, 2003 at 08:09:19PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Marc Zyngier <mzyngier@freesurf.fr>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Jul 01, 2003 at 08:09:19PM +0200, Marc Zyngier wrote:
> James,
> 
> The included patch fixes a few bits that were missing when you merged
> my aha1740 patch (mainly errors handling, and a release method).

aha1740 is a newstyle driver and doesn't need a release method so
this is bogus.

