From: Christoph Hellwig <hch@infradead.org>
Subject: Re: increasing host numbers
Date: Tue, 24 Jun 2003 12:43:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030624124327.A8155@infradead.org>
References: <3EF808FA.5020503@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:5387 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261970AbTFXL3U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 07:29:20 -0400
Content-Disposition: inline
In-Reply-To: <3EF808FA.5020503@torque.net>; from dougg@torque.net on Tue, Jun 24, 2003 at 06:16:58PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jun 24, 2003 at 06:16:58PM +1000, Douglas Gilbert wrote:
> It seems as though host numbers are no longer re-used.
> This pattern started in lk 2.5.73:

So far this was intentional, so I'd call it a feature.  If you think
this is not good we can add some kind of bitmap to get free host number.

