From: Martin Hicks <mort@wildopensource.com>
Subject: Re: [PATCH] Fix error path when adding sysfs attributes
Date: Fri, 16 Jan 2004 15:33:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116203325.GX27591@localhost>
References: <20040116192801.GT27591@localhost> <20040116194839.GA1053@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:59799 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S265818AbUAPUda (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 15:33:30 -0500
Content-Disposition: inline
In-Reply-To: <20040116194839.GA1053@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Mike Anderson <andmike@us.ibm.com>



On Fri, Jan 16, 2004 at 11:48:39AM -0800, Mike Anderson wrote:
> While we are cleaning there appears to also be an extra return on line
> 364 after a goto. It might be good to include this change in the patch.
> 

Good idea.  Here's an updated patch that fixes the original bugs, the
extra "return" and a bit of whitespace.

thanks
mh

-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296
