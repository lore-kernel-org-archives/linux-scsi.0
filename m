From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH] scsi: Allow 64-bit LUNs during report lun scan
Date: Thu, 14 Feb 2013 16:38:23 -0600
Message-ID: <511D675F.6020009@tributary.com>
References: <1360767971-947-1-git-send-email-hare@suse.de>  <511BEF0B.4020302@tributary.com> <1360813101.2502.8.camel@dabdike> <511D26B4.6070302@tributary.com> <94D0CD8314A33A4D9D801C0FE68B402950D58E9A@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:53700 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759350Ab3BNWi0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2013 17:38:26 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402950D58E9A@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2/14/2013 4:04 PM, Elliott, Robert (Server Storage) wrote:
> Like James notes, LUNs should generally be treated as opaque values.

	I agree, except there is a max host lun check based on a decoded lun value. Not
really sure why its there other than maybe some of the HBA's have resource
issues with a large number of luns.

> scsilun_to_int() does not appear to be used very much; I see 35 matches in linux-3.7-rc5. Perhaps the callers should be updated to support 64-bit LUNs and decide what to do if they cannot handle larger values.


	Which is a perfectly valid fix, but if that is being done, why do any swizzling
in scsilun_to_int()?

