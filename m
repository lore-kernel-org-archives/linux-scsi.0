From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix up scsi_test_unit_ready() to work correctly with CD-ROMs
Date: Sat, 11 Sep 2004 11:35:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040911113550.A1053@infradead.org>
References: <1094738299.1837.2.camel@mulgrave> <41412790.70705@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:48905 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268082AbUIKKf6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Sep 2004 06:35:58 -0400
Content-Disposition: inline
In-Reply-To: <41412790.70705@torque.net>; from dougg@torque.net on Fri, Sep 10, 2004 at 02:03:28PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Sep 10, 2004 at 02:03:28PM +1000, Douglas Gilbert wrote:
> James,
> Is the "descriptor" sense data patch which Christoph and I
> worked on likely to be accepted?

That patch (and I'd rather say it's yours because you did the hard work :))
is in now.

