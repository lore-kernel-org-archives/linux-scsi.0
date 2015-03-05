From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Thu, 5 Mar 2015 05:23:37 -0800
Message-ID: <20150305132337.GA32341@infradead.org>
References: <54B7E70C.8020304@sandisk.com>
 <20150119092153.GA8666@infradead.org>
 <54BCD00D.4080603@sandisk.com>
 <54E7112F.2080901@sandisk.com>
 <1424476807.1477.52.camel@haakon3.risingtidesystems.com>
 <54ED8B38.10904@sandisk.com>
 <1425074315.30923.74.camel@haakon3.risingtidesystems.com>
 <54F1ADAF.90808@sandisk.com>
 <1425279574.13530.53.camel@haakon3.risingtidesystems.com>
 <54F6DD3B.4030207@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbbCENXn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 08:23:43 -0500
Content-Disposition: inline
In-Reply-To: <54F6DD3B.4030207@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@infradead.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is exactly why I didn't want to put this topic onto the LSF agenda.

There are tons of very useful fixes and cleanus in Barts series, and I'd
really like to get them in ASAP.

As Nic pointed out (in a slightly unhelpful tone) we're not interested
in adding any hooks for out of tree code.  But if SCST needs hooks it
should eithe switch to the in-kerel way of doing it, or if has a clearly
better way of doing it merge that into the kernel.  I'm pretty sure
there are various pieces that would make a lot of sense to merge either
way, and getting towards a single target with a broad maintainer and
user base seem like a way better approach that adding weird hooks.  But
I don't think that's even on the table for LSF this year, maybe next
year if everyone involved works hard on it.
