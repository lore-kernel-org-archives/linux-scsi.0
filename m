From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Ultra 160 - what HA works well with 2.4 and 2.6?
Date: Fri, 7 Nov 2003 11:24:08 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031107112408.B3302@infradead.org>
References: <20031104103929.GA9585@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:61202 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264084AbTKGLYJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 06:24:09 -0500
Content-Disposition: inline
In-Reply-To: <20031104103929.GA9585@merlin.emma.line.org>; from ma+lscsi@dt.e-technik.uni-dortmund.de on Tue, Nov 04, 2003 at 11:39:29AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma+lscsi@dt.e-technik.uni-dortmund.de>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 04, 2003 at 11:39:29AM +0100, Matthias Andree wrote:
> Are there concerns that I should be aware of, for instance Dave Jones'
> post-halloween-2003 doc (http://www.codemonkey.org.uk/post-halloween-2.5.txt)
> mentions error handling, are there non-obvious concerns affecting the
> qla1280 and sym53c8xx_2 drivers? Which works better? Anything else I
> should consider?

I'd say both are fine, look for the price :) for the qlogic one make sure
you're using the recent driver from Jes as included in 2.6 or 2.4.23pre,
not the one from qlogic.

> Does it make a difference which brand the card will be? I have good
> experience with the 53C875 based Tekram cards so far, but U160 is a
> different League than UWSCSI.

I don't think the vendor matters that much these days, there's not a lot
to wire left on the boards and the driver is the same anyway.

