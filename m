From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] Use a more selective error recovery strategy based on
 device capabilities
Date: Thu, 14 Feb 2013 14:57:25 -0600
Message-ID: <511D4FB5.708@tributary.com>
References: <511A87CA.5010901@tributary.com> <511B8FBF.9000705@suse.de> <511BB545.7060600@tributary.com> <12DB2383-B7CE-4DD4-BBAA-D6701271A6E6@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:45487 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588Ab3BNU53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2013 15:57:29 -0500
In-Reply-To: <12DB2383-B7CE-4DD4-BBAA-D6701271A6E6@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, Linux Scsi <linux-scsi@vger.kernel.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>

On 2/13/2013 8:43 PM, Michael Christie wrote:
> For the case where report supported TMFs is not supported can we just have the LLD return some new return code from the eh callback when it gets FUNCTION_REJECTED. scsi-ml would then clear the eh_*_ok bit, so at least it would not be called again..


	Hmm, that seems like a good idea. The question is, does propagating the flag
change to all the devices on the I_T make sense?



