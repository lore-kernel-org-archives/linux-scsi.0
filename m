From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: fusion problems on 64bit hosts
Date: 27 Sep 2004 18:20:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096323650.2035.86.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57050F84D0@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:56987 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267405AbUI0WVF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 18:21:05 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57050F84D0@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: Eric Dean Moore <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>

On Mon, 2004-09-27 at 18:12, Moore, Eric Dean wrote:
> No, we are not keeping a 64bit pointer in a 32bit hardware register.
> IMO we can solve this issue by adding ppc64 to define above.

Assuming this is the correct thing to do, what's wrong with predicating
on 

#ifdef __LP64__

instead?

That way you don't have to keep this list of 64 bit architectures up to
date

James

