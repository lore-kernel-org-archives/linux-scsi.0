From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] libata: Report zeroed read after Trim and max
	discard size
Date: Tue, 24 Nov 2009 10:21:46 -0500
Message-ID: <20091124152146.GA15276@infradead.org>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <1258771524-26673-4-git-send-email-martin.petersen@oracle.com> <20091121104923.GB30153@infradead.org> <yq11vjrskfu.fsf@sermon.lab.mkp.net> <20091124143508.GB21629@infradead.org> <4B0BF9BC.3080006@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56804 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757343AbZKXPVw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 10:21:52 -0500
Content-Disposition: inline
In-Reply-To: <4B0BF9BC.3080006@teksavvy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Nov 24, 2009 at 10:20:28AM -0500, Mark Lord wrote:
> I suppose that buffer would be only 512 bytes long, per device?
> That might be a bit restrictive, as TRIM can handle much larger
> requests, and some drives (Indinlinx-based at least) prefer large
> TRIM lists at present.

Allocating a buffer per device would allow it to be much larger.


