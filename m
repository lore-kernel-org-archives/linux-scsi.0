From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: 21 Apr 2004 10:40:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082562046.1932.16.camel@mulgrave>
References: <20040418185751.GC4868@tpkurt.garloff.de>
	<1082330192.1969.37.camel@mulgrave>
	<20040420115419.GG4356@tpkurt.garloff.de>
	<1082471881.1804.34.camel@mulgrave>
	<20040420160334.GO4356@tpkurt.garloff.de>
	<20040421134511.GP28633@tpkurt.garloff.de>
	<20040421141417.GV28633@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:36771 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263203AbUDUPks (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 11:40:48 -0400
In-Reply-To: <20040421141417.GV28633@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Patrick Mansfield <patmans@us.ibm.com>

On Wed, 2004-04-21 at 09:14, Kurt Garloff wrote:
> Don't attach high level drivers (except sg) to devices with peripheral
> qualifier indicating not connected (1) or not capable (3).
> SPC3, 7.4.2.

I'd really rather the pq field became part of struct scsi_device (just
like type is) so that it's parsed out in one place (scsi_scan.c) on the
initial inquiry.  Then each ULD can simply look in that field.

This will future proof us against any expansion of the field.

James

