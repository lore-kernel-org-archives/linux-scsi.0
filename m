From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Full hostlock pushdown available
Date: Thu, 28 Oct 2010 23:50:17 +0200
Message-ID: <20101028215017.GB2797@basil.fritz.box>
References: <20101028150508.GA2385@basil.fritz.box>
 <1288294123.3043.164.camel@mulgrave.site>
 <20101028201036.GA2797@basil.fritz.box>
 <1288297365.10498.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:34743 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab0J1VuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 17:50:21 -0400
Content-Disposition: inline
In-Reply-To: <1288297365.10498.4.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

> To put this upstream, I need the single commit (with changelog and
> signoff).  Otherwise the series won't bisect.  Murphys law says that if
> I apply an unbisectable series like this, all the kernel bisections in
> the next few months will end up in here, and I'll take a huge amount of
> flack ...

I expect even without the locking it should be safe enough for a bisect
test. Not for production of course. And most drivers don't really
need the lock anyways so they are safe in any case.

An alternative would be to use a different lock around the call
temporary during the series and drop it again at the end.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
