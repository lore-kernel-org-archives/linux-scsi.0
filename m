From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] [PATCH 2.6.9-rc1] add blacklist attribute indicating no
	ULD attach
Date: 15 Sep 2004 09:25:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095254765.1717.0.camel@mulgrave>
References: <20040914063237.GA97486@sgi.com>
	<20040914144023.GA9524@beaverton.ibm.com> <20040914182203.GA100433@sgi.com>
	<20040915031834.GA102988@sgi.com>  <20040915074744.A17264@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:55744 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265999AbUION0d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 09:26:33 -0400
In-Reply-To: <20040915074744.A17264@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>, Jens Axboe <axboe@suse.de>

On Wed, 2004-09-15 at 02:47, Christoph Hellwig wrote:
> don't we already carry around the blacklist flags in the scsi dev so
> they could be checked laer?  If not maybe we should instead of adding
> more and more flags?

Not in this case ... I'm planning a wider use of this flag for a lazy
attachment idea I'm hatching.

James


