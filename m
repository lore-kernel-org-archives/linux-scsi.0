From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3.15 099/139] libiscsi, iser: Adjust data_length to
 include protection information
Date: Wed, 2 Jul 2014 23:05:48 -0700
Message-ID: <20140703060548.GB17456@infradead.org>
References: <20140628174605.352098823@linuxfoundation.org>
 <20140628174609.930049472@linuxfoundation.org>
 <1404339330.1862.69.camel@ul30vt.home>
 <53B48B37.4000608@cs.wisc.edu>
 <1404341555.16066.19.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59125 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaGCGFy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 02:05:54 -0400
Content-Disposition: inline
In-Reply-To: <1404341555.16066.19.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Alex Williamson <alex.williamson@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Jul 02, 2014 at 03:52:35PM -0700, James Bottomley wrote:
> In which case it's not marked for stable backport ... I assume it should
> be?

Only if the patch that regression went to stable, which it shouldn't,

