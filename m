From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] scsi: megaraid_sas - add module param max_sectors, cmd_per_lun
Date: Fri, 14 Sep 2007 11:38:50 +0100
Message-ID: <20070914103850.GA15225@infradead.org>
References: <1189514073.6082.14.camel@dhcp-75-534.se.lsil.com> <20070914033216.858d12e0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46575 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbXINKi5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 06:38:57 -0400
Content-Disposition: inline
In-Reply-To: <20070914033216.858d12e0.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-box <bo.yang@lsi.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, sumant.patro@lsi.com

On Fri, Sep 14, 2007 at 03:32:16AM -0700, Andrew Morton wrote:
> y'know, if some brave soul were to write

y'know - some brave sould already did it.

> static inline void *scsi_host_data(struct Scsi_Host *host)
> {
> 	return (void *)host->hostdata;
> }
> 
> we could remove about 100000000000 ugly casts from scsi.

it's called shost_priv, but I couldn't get a whole lot of driver
authors to switch over yet.
