From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] cciss: kconfig patch to make cciss dependent on
	scsi for SG_IO ioctl
Date: Thu, 12 Apr 2007 17:07:15 -0500
Message-ID: <1176415635.3711.25.camel@mulgrave.il.steeleye.com>
References: <20070412212741.GA10654@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60922 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030784AbXDLWI0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Apr 2007 18:08:26 -0400
In-Reply-To: <20070412212741.GA10654@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, steve.cameron@hp.com

On Thu, 2007-04-12 at 16:27 -0500, Mike Miller (OS Dev) wrote:
> This kconfig patch makes cciss dependent on scsi for the new SG_IO ioctl we just
> added. If cciss is built into the kernel it makes sures that scsi is also statically
> linked. If scsi is a module then cciss will also be built as a module. Please consider
> this for inclusion.

Erm, I don't think this is necessary: SG_IO is a property of the block
layer, not SCSI (as in it will work without SCSI even present).  SCSI
has a special driver: the sg driver that has its own implementation of
SG_IO, but that's the only connection.

James


