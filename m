From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v1 3/5] isci: debug, provide state-enum-to-string
 conversions
Date: Sun, 19 Feb 2012 09:17:40 -0600
Message-ID: <1329664660.2806.3.camel@dabdike.int.hansenpartnership.com>
References: <20120210091814.26719.75603.stgit@dwillia2-linux.jf.intel.com>
	 <20120210091844.26719.10844.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51155 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978Ab2BSPRm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2012 10:17:42 -0500
In-Reply-To: <20120210091844.26719.10844.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2012-02-10 at 01:18 -0800, Dan Williams wrote:
> Debugging the driver requires tracing the state transtions and tracing
> state names is less work than decoding numbers.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I've got 1 now and 2 was sent as a previous patch, so I have it.  This
one doesn't apply:

patching file drivers/scsi/isci/phy.c
Hunk #2 succeeded at 456 (offset -8 lines).
Hunk #3 succeeded at 482 (offset -8 lines).
Hunk #4 succeeded at 496 (offset -8 lines).
Hunk #5 succeeded at 546 (offset -8 lines).
Hunk #6 succeeded at 872 (offset -8 lines).
Hunk #7 succeeded at 966 (offset -8 lines).
patching file drivers/scsi/isci/phy.h
Hunk #1 succeeded at 344 (offset 1 line).
patching file drivers/scsi/isci/port.c
Hunk #1 FAILED at 60.
Hunk #2 succeeded at 1097 (offset 43 lines).
Hunk #3 succeeded at 1172 (offset 43 lines).
Hunk #4 succeeded at 1187 (offset 43 lines).
Hunk #5 succeeded at 1282 (offset 43 lines).
Hunk #6 succeeded at 1332 (offset 43 lines).
Hunk #7 succeeded at 1375 (offset 43 lines).
Hunk #8 succeeded at 1405 (offset 43 lines).
Hunk #9 succeeded at 1425 (offset 43 lines).
Hunk #10 succeeded at 1440 (offset 43 lines).
1 out of 10 hunks FAILED -- saving rejects to file
drivers/scsi/isci/port.c.rej
patching file drivers/scsi/isci/port.h
Hunk #1 succeeded at 147 (offset 3 lines).
patching file drivers/scsi/isci/remote_device.c
patching file drivers/scsi/isci/remote_device.h
Hunk #1 succeeded at 180 (offset 1 line).
patching file drivers/scsi/isci/remote_node_context.c
patching file drivers/scsi/isci/remote_node_context.h
patching file drivers/scsi/isci/request.c
Hunk #2 succeeded at 957 (offset 37 lines).
Hunk #3 succeeded at 979 (offset 37 lines).
Hunk #4 succeeded at 2466 (offset 149 lines).
patching file drivers/scsi/isci/request.h
Hunk #1 FAILED at 182.
1 out of 1 hunk FAILED -- saving rejects to file
drivers/scsi/isci/request.h.rej

James


