From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: dpt_i2o driver
Date: Tue, 26 Aug 2003 17:51:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030826175135.B29235@infradead.org>
References: <0998F43EAD645A47B3F6507196DD70EA2568DE@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:34823 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262866AbTHZQvh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2003 12:51:37 -0400
Content-Disposition: inline
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA2568DE@OTCEXC01>; from mark_salyzyn@adaptec.com on Tue, Aug 26, 2003 at 11:02:48AM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Aug 26, 2003 at 11:02:48AM -0400, Salyzyn, Mark wrote:
> I am close to completing tests surrounding the dpt_i2o driver to support 2.4
> + 2.6 kernels as well as bigmem DMA issues. Who, if anyone, has been
> designated as the person to accept this updated driver?

Please send it to this list. James Bottomley is official SCSI maintainer
for 2.6 but scsi development and code review is a distributed effort
these days.

