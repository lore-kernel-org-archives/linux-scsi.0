From: Christoph Hellwig <hch@infradead.org>
Subject: Re: T10-PI: Getting failed tag info
Date: Mon, 15 Dec 2014 00:18:57 -0800
Message-ID: <20141215081857.GA24067@infradead.org>
References: <54892468.5060300@vlnb.net>
 <yq1r3w5blys.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40213 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaLOITB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2014 03:19:01 -0500
Content-Disposition: inline
In-Reply-To: <yq1r3w5blys.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org

On Thu, Dec 11, 2014 at 10:12:11PM -0500, Martin K. Petersen wrote:
> block: Add specific data integrity errors
> 
> Introduce a set of error codes that can be used by the block integrity
> subsystem to signal which class of error was encountered by either the
> I/O controller or the storage device.

I really don't like adding new errno codes for all these.  I'd much
rather have a integrity error field with specific codes in the bio.
