From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Full hostlock pushdown available
Date: Mon, 1 Nov 2010 15:06:01 +0100
Message-ID: <20101101140601.GF25817@basil.fritz.box>
References: <20101028150508.GA2385@basil.fritz.box>
 <1288294123.3043.164.camel@mulgrave.site>
 <1288294322.5169.285.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:48688 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab0KAOGC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 10:06:02 -0400
Content-Disposition: inline
In-Reply-To: <1288294322.5169.285.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org

> > OK, so can you post an actual diff?  It obviously has to be done in one
> > commit rather than the 87 you have.
> > 
> 
> So it appears this series will still need the atomic_add_return() usage
> in scsi_cmd_get_serial() and drop host_lock usage from those LLDs that
> we know can be converted to 'host_lock-less', yes..?

Yes that is correct. The series is just a dumb push down, no additional
improvements (except some very minor ones).  These patches
are still needed in addition, so it would be just a base for it

Also James if you use the patch and don't pull 
please regenerate it from the git tree (or tell me to send it again) -- 
i did some fixes based on feedback.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
