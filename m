From: "Koskinen Aaro (NSN - FI/Helsinki)" <aaro.koskinen@nsn.com>
Subject: Re: [PATCH 1/1] sym53c8xx_2: Fix validation (Fix hotplug support).
Date: Mon, 18 Aug 2008 19:38:57 +0300
Message-ID: <48A9A5A1.1010106@nsn.com>
References: <1219004320-6384-1-git-send-email-michaelc@cs.wisc.edu>	 <1219030321.3917.44.camel@localhost.localdomain>	 <48A8F0D8.3030000@cs.wisc.edu> <1219068634.3261.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:61295 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYHRQjx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Aug 2008 12:39:53 -0400
In-Reply-To: <1219068634.3261.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ext James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

ext James Bottomley wrote:
> Actually, the report says everything goes fine if they notify the mid
> layer through sysfs before doing the removal.  The problem is on
> unnotified hot swap with a rescan afterwards.
> 
> The problem in the second case is the parameter mismatch.  The HBA is
> thinking previous transfer parameters and the drive is thinking async.

The mid-layer notification has no effect on the sym driver, the result 
is exactly the same as with the unnotified hot swap.

A.
