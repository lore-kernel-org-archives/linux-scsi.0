From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: 27 Feb 2004 09:08:18 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077894499.1806.14.camel@mulgrave>
References: <1077842444.2662.123.camel@mulgrave>
	<20040227124811.A32109@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:64215 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262966AbUB0PI1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 10:08:27 -0500
In-Reply-To: <20040227124811.A32109@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Collins <bcollins@debian.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-02-27 at 06:48, Christoph Hellwig wrote:
> Well, the last patch looks sane if we want to do that.  But didn't we
> declare the mononically increasing host numbers a feature?

This is the part that worries me too.  At the moment with monotonically
increasing host numbers, the operation of scsi_host_lookup() is provably
safe.  Can we prove that all uses of it are still safe if we reuse the
host numbers?

James


