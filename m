From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] make the SCSI mid-layer obey the device online flag
Date: Wed, 4 Jun 2003 17:34:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030604173413.A9632@beaverton.ibm.com>
References: <1054742495.1674.18.camel@mulgrave> <20030604165146.GA1426@beaverton.ibm.com> <1054754103.2360.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:6099 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S264336AbTFEAZJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2003 20:25:09 -0400
Content-Disposition: inline
In-Reply-To: <1054754103.2360.8.camel@mulgrave>; from James.Bottomley@steeleye.com on Wed, Jun 04, 2003 at 03:14:56PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

I thought that USB sending a command after online cleared was likely the
last prepped request being sent. This can't be fixed within scsi_prep_fn,
since it will not be called for the last request after online is cleared.

So we might as well move all the checking of online into the
scsi_request_fn.

-- Patrick Mansfield
