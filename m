From: Colin Keith <linux-scsi@ckeith.clara.net>
Subject: Re: kernel oops with aacraid 1.1-5[2409]-mh1 under 2.6.17-1.2187_FC5
Date: Wed, 18 Oct 2006 19:03:11 +0100
Message-ID: <20061018180311.GH1243@dot.oreally.co.uk>
References: <20061018163357.GG1243@dot.oreally.co.uk> <1161193331.15307.11.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dot.reactive-networks.net ([217.144.82.11]:62983 "EHLO
	dot.oreally.co.uk") by vger.kernel.org with ESMTP id S1422629AbWJRSDN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 14:03:13 -0400
Content-Disposition: inline
In-Reply-To: <1161193331.15307.11.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Oct 18, 2006 at 10:42:11AM -0700, Mark Haverkamp wrote:
> There was a patch checked in that removed some un-needed list_head
> elements post 2.6.17.   I believe that there were reports of list
> corruption problems that this patch solved.  The 2.6.18-1.2200-fc5 has
> this patch.

Thank you (lots!!).

As that's what I'm now running I'll keep an eye on this and see if it has
any further problems and report and further errors that occur.

Regards,
Colin.

-- 
 "Developers are like artists; they produce their best work if they
  have the freedom to do so" - Werner Vogels, CTO Amazon.com
