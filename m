From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fix all REQ_BLOCK_PC retries and requeues (take2)
Date: Sun, 18 Sep 2005 18:14:09 -0500
Message-ID: <1127085249.3025.2.camel@max>
References: <1127077492.2728.2.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:26323 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932252AbVIRXOT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Sep 2005 19:14:19 -0400
In-Reply-To: <1127077492.2728.2.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@suse.de

On Sun, 2005-09-18 at 16:04 -0500, Mike Christie wrote:
> sd and st handle REQ_BLOCK_PC command setup the same, and


crap, I need to go to sleep. I guess those other patches here
http://marc.theaimsgroup.com/?l=linux-scsi&m=112708362822874&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=112708367105404&w=2
were right because sr wants is special.

