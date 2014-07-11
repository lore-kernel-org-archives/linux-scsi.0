From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] megaraid_sas: Add missing initial call to
 megasas_get_ld_vf_affiliation().
Date: Fri, 11 Jul 2014 02:56:21 -0700
Message-ID: <20140711095621.GB4216@infradead.org>
References: <1404944278-11535-1-git-send-email-aradford@gmail.com>
 <1404944278-11535-5-git-send-email-aradford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaGKJ4V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2014 05:56:21 -0400
Content-Disposition: inline
In-Reply-To: <1404944278-11535-5-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@gmail.com>
Cc: linux-scsi@vger.kernel.org, uday.lingala@avagotech.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

On Wed, Jul 09, 2014 at 03:17:57PM -0700, Adam Radford wrote:
> The following patch for megaraid_sas adds a missing initial call to
> megasas_get_ld_vf_affiliation() at the end of megasas_probe_one().
> 
> Signed-off-by: Adam Radford <aradford@gmail.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
