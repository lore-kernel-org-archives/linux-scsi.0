From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 12/18] megaraid_sas : add endianess annotations
Date: Mon, 11 May 2015 02:20:22 -0700
Message-ID: <20150511092022.GI28820@infradead.org>
References: <201504231105.t3NB5Al0030484@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbbEKJUX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 05:20:23 -0400
Content-Disposition: inline
In-Reply-To: <201504231105.t3NB5Al0030484@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On Thu, Apr 23, 2015 at 04:32:54PM +0530, Sumit.Saxena@avagotech.com wrote:
> This adds endianness annotations to all data structures, and a few
> variables directly referencing them.
> 
> From: Christoph Hellwig <hch@lst.de>

This needs to be at the beginning of the message body, just like
in the previous patch.
