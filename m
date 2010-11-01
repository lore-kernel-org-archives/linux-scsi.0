From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Full hostlock pushdown available
Date: Mon, 01 Nov 2010 10:29:50 -0400
Message-ID: <1288621790.3056.36.camel@mulgrave.site>
References: <20101028150508.GA2385@basil.fritz.box>
	 <1288294123.3043.164.camel@mulgrave.site>
	 <1288294322.5169.285.camel@haakon2.linux-iscsi.org>
	 <20101101140601.GF25817@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461Ab0KAO3z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Nov 2010 10:29:55 -0400
In-Reply-To: <20101101140601.GF25817@basil.fritz.box>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Mon, 2010-11-01 at 15:06 +0100, Andi Kleen wrote:
> > > OK, so can you post an actual diff?  It obviously has to be done in one
> > > commit rather than the 87 you have.
> > > 
> > 
> > So it appears this series will still need the atomic_add_return() usage
> > in scsi_cmd_get_serial() and drop host_lock usage from those LLDs that
> > we know can be converted to 'host_lock-less', yes..?
> 
> Yes that is correct. The series is just a dumb push down, no additional
> improvements (except some very minor ones).  These patches
> are still needed in addition, so it would be just a base for it
> 
> Also James if you use the patch and don't pull 
> please regenerate it from the git tree (or tell me to send it again) -- 
> i did some fixes based on feedback.

You can separate the Doc commits, but the lock pushdown still has to be
a single commit for bisectability.  If you respin the patch, I can add
the description if you want.

James


