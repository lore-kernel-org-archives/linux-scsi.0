From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 00/17] Open-FCoE Updates
Date: Wed, 25 Feb 2009 20:49:33 -0600
Message-ID: <49A6033D.8040600@cs.wisc.edu>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50927 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbZBZCto (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2009 21:49:44 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

Robert Love wrote:
> The following series implements bug fixes, adds a module param for runtime debug logging and cleans up some coding style issues. The top patch is a patch that was posted to linux-scsi on 01/04, but doesn't seem to have made it in yet.
> 
> This patch set is based on Linus' tree + the Open-FCoE patches submitted to linux-scsi on 01/21.
> 

Were these patches and that other patchset for 2.6.29-rc? This one had 
some non bug fixes. I was not sure if you can do that in a rc. I was not 
sure if because it is a new driver you get a exception since there can 
be no regressions.

The first bunch of patches from 1/21 look ok.

The patches below looked ok too. I was not sure about the underrun 
handling in this one though:

> Vasu Dev (1):
>       libfc: fixed a read IO data integrity issue when a IO data frame lost
> 

I always mess underrun handling up.

Other patches looked ok.

Reviewed-by: Mike Christie <micaelc@cs.wisc.edu>
