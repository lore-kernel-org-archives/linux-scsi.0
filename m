From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH 1/2] scsi_scan: Send TEST UNIT READY to the LUN before
 scanning
Date: Wed, 11 Jun 2014 10:04:56 -0500
Message-ID: <53987018.4030705@tributary.com>
References: <1401953203-103015-1-git-send-email-hare@suse.de>	 <1401953203-103015-2-git-send-email-hare@suse.de> <1402496658.2523.7.camel@dabdike.int.hansenpartnership.com> <539868C2.50406@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:2283 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbaFKPFA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 11:05:00 -0400
In-Reply-To: <539868C2.50406@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 6/11/2014 9:33 AM, Hannes Reinecke wrote:
> _If_ we were attempting this we'd run into several issues: a) Boot will
> fail, as REPORT LUNs will return 0 LUNs (or just LUN 0). So the scanning
> code will assume everything's fine. Booting will continue, only to figure
> out that no LUNs are present. As there is _no_ indication that REPORT LUNs
> should indeed have returned an error (only it can't due to SAM) we wouldn't
> even now that there _is_ an issue. (In fact, that's what triggered the
> patchset in the first place.)

	Isn't this what the root mount delay is for? I've had to use that on
assorted embedded devices in the past, and it doesn't seem ideal but it solves
the larger problem (because maybe there isn't even anything to send the TUR to).





