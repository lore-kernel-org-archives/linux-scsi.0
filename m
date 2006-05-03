From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: request to add aic94xx to -mm
Date: Wed, 03 May 2006 09:02:53 -0500
Message-ID: <1146664974.3346.7.camel@mulgrave.il.steeleye.com>
References: <1146243246.5251.29.camel@mulgrave.il.steeleye.com>
	 <20060428174623.GA17119@infradead.org>  <445775A6.2070302@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:10890 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030214AbWECODN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 May 2006 10:03:13 -0400
In-Reply-To: <445775A6.2070302@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-05-02 at 11:07 -0400, Jeff Garzik wrote:
> James, what is the canonical aic94xx home now?

There's currently no canonical form.  The home of the development tree
that's feeding into -mm is aic94xx-sas-2.6.git but that will be
flattened before being merged into scsi-misc-2.6

James


