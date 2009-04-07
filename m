From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [GIT PATCH] final set of SCSI updates for the merge window
Date: Tue, 7 Apr 2009 14:34:46 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.0904071433440.27739@twin.jikos.cz>
References: <1239033266.3641.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56014 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZDGMey (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2009 08:34:54 -0400
In-Reply-To: <1239033266.3641.9.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 6 Apr 2009, James Bottomley wrote:

> Adrian Bunk (3):
[ ... ]
>       ses: #if 0 the unused ses_match_host()

I never understood why should we "#if 0" unused code in mainline tree 
rather just removing it unless it has real users?

-- 
Jiri Kosina
SUSE Labs

