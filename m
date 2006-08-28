From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_transport_sas: remove local_attached flag
Date: Mon, 28 Aug 2006 09:01:36 -0500
Message-ID: <1156773696.3465.5.camel@mulgrave.il.steeleye.com>
References: <1156531698.3462.11.camel@mulgrave.il.steeleye.com>
	 <20060828093012.GB8980@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45203 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750830AbWH1OBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 10:01:43 -0400
In-Reply-To: <20060828093012.GB8980@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsil.com>

On Mon, 2006-08-28 at 10:30 +0100, Christoph Hellwig wrote:
> You can of course do the reset and stats using the normal smp code from
> libsas for fusion aswell.  I just added the flag as a quick hack because
> I was waiting for the libsas merge to implement this instead of adding
> a mptsas-specific implementation.

Well ... we need an SMP input for that, which mptsas doesn't provide.
If it did, we could move SMP execution out of libsas into the transport
class proper and use it for the non-local expander stuff.

James


