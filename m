From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Tue, 20 Jan 2004 13:21:58 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120132158.A15548@infradead.org>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <20040119193354.GC967@beaverton.ibm.com> <400CC32C.8060601@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:45061 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265488AbUATNWG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 08:22:06 -0500
Content-Disposition: inline
In-Reply-To: <400CC32C.8060601@torque.net>; from dougg@torque.net on Tue, Jan 20, 2004 at 03:57:00PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org

On Tue, Jan 20, 2004 at 03:57:00PM +1000, Douglas Gilbert wrote:
> ... and will MODULE_VERSION be defined when the driver is built in?

Given the tradition of the MODULE_ macros it will certinaly be defined.
For details on what it actually does in the built-in case ask Rusty.

