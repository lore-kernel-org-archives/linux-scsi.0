From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/17] scsi: avoid useless free_list lock roundtrips
Date: Thu, 6 Feb 2014 08:22:30 -0800
Message-ID: <20140206162230.GF16916@infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
 <20140205124019.577883829@bombadil.infradead.org>
 <1391643844.2213.62.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58035 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaBFQWb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 11:22:31 -0500
Content-Disposition: inline
In-Reply-To: <1391643844.2213.62.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Wed, Feb 05, 2014 at 03:44:04PM -0800, James Bottomley wrote:
> Why do this?  cmd is still likely to be not NULL, which helps the
> compiler optimise.

Because testing for non-NULL pointers gets that hint implicitly from
gcc.

