From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 0/1] Resend of zfcp adapter statistics
Date: Thu, 28 Feb 2008 10:42:35 +0100
Message-ID: <20080228094235.GB10590@schmichrtp.de.ibm.com>
References: <20080107164330.733068000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:65340 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbYB1Jmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Feb 2008 04:42:38 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.8/8.13.8) with ESMTP id m1S9gasc268058
	for <linux-scsi@vger.kernel.org>; Thu, 28 Feb 2008 09:42:36 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1S9gave2113654
	for <linux-scsi@vger.kernel.org>; Thu, 28 Feb 2008 10:42:36 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1S9gaaY015168
	for <linux-scsi@vger.kernel.org>; Thu, 28 Feb 2008 09:42:36 GMT
Content-Disposition: inline
In-Reply-To: <20080107164330.733068000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>

On Mon, Jan 07, 2008 at 05:43:30PM +0100, Christof Schmitt wrote:
> this is the extension for zfcp that adds some statistics retrieved
> from the FCP adapter. This version already includes the fixes and
> applies on top of the other patches on scsi-misc.
> 
> Like Swen mentioned before, this adds new data attributes that only
> refer to one Linux system. Similar looking attributes for the FC host
> refer to the adapter. Since the FCP adapter can be shared across
> multiple Linux systems, the two groups of attributes have a different
> scope.

James,

do you have any objections or comments for this zfcp extension?

These patches are currently sitting at the head of our internal patch
queue and block the submission of other patches. What do we have to
change to include these patches? If there is major rework required, i
will probably first send other cleanup patches.

--
Christof Schmitt
