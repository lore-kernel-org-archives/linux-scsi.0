From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dpt_i2o in 2.6.0_test*
Date: Mon, 11 Aug 2003 19:49:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030811194947.A5859@infradead.org>
References: <20030809211706.A1938@infradead.org> <Pine.GSO.4.33.0308111442040.7750-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:272 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S273018AbTHKStw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 14:49:52 -0400
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.33.0308111442040.7750-100000@sweetums.bluetronic.net>; from jfbeam@bluetronic.net on Mon, Aug 11, 2003 at 02:44:32PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: Christoph Hellwig <hch@infradead.org>, "Alexandru N. Barloiu" <slak@dale.ro>, linux-scsi@vger.kernel.org

On Mon, Aug 11, 2003 at 02:44:32PM -0400, Ricky Beam wrote:
> On Sat, 9 Aug 2003, Christoph Hellwig wrote:
> >According to Alan the fix is to use the i2o_scsi driver instead.
> 
> Doing so removes support for DPT's RAID management software.
> 
> Start screaming at Adaptec to update their stinking driver!

Or port their managment software to the generic i2o driver.  Once
someone did that we should probably completly kill off dpt_i2o - it's
really pointless to have a vendor driver if there's a class driver
already.  And given certain issues we have with vendor driver quality..

