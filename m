From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 64-bit SCSI LUN addressing on Linux
Date: Thu, 30 Jun 2005 17:11:24 +0100
Message-ID: <20050630161124.GA29852@infradead.org>
References: <42C41745.1020302@datadirectnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:18311 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S263000AbVF3QLa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jun 2005 12:11:30 -0400
Content-Disposition: inline
In-Reply-To: <42C41745.1020302@datadirectnet.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin W. Schlining III" <mschlining@datadirectnet.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Jun 30, 2005 at 12:01:09PM -0400, Martin W. Schlining III wrote:
> Does Linux support 64-bit SCSI LUN addressing? Suppose I have a system 
> that can create SCSI LUNs that are greater than 2TB using a block size 
> of 512 bytes and can accept 16 byte CDBs, can I use this LUN with a 2.6 
> series Linux kernel?

Yes.

> If so, are there any filesystems (ext3, XFS, etc. ) that can use a LUN > 
> 2TB?

XFS has been tested heavily with big luns, but the others should work
aswell.

> Would I need any additional tools?

no.

> Would I need a 64-bit platform?

For filesystem sizes < 16TB you can use 32bit platforms, above that you
need a 64bit kernel.

