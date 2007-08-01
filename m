From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] Coding style fix drivers/scsi/aha1542.c
Date: Wed, 1 Aug 2007 16:18:12 +0100
Message-ID: <20070801151812.GA17601@infradead.org>
References: <46B0A30A.8090500@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50427 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934762AbXHAPSP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 11:18:15 -0400
Content-Disposition: inline
In-Reply-To: <46B0A30A.8090500@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Wed, Aug 01, 2007 at 05:13:14PM +0200, Michal Piotrowski wrote:
> Hi,
> 
> Coding style fix
> 
> Regards,
> Michal
>

I think that include should just go.  There is no reason at all for
a scsi driver to include stat.h

