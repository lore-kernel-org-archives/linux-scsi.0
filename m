From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Patches for SCSI scanning
Date: 21 Apr 2004 10:36:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082561763.1934.12.camel@mulgrave>
References: <20040418185751.GC4868@tpkurt.garloff.de>
	<1082330192.1969.37.camel@mulgrave>
	<20040420115419.GG4356@tpkurt.garloff.de>
	<1082471881.1804.34.camel@mulgrave>
	<20040420160334.GO4356@tpkurt.garloff.de>
	<1082477331.2191.44.camel@mulgrave>
	<20040421134846.GQ28633@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:20131 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263226AbUDUPgG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 11:36:06 -0400
In-Reply-To: <20040421134846.GQ28633@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Wed, 2004-04-21 at 08:48, Kurt Garloff wrote:
> Any ideas?
> We need to use full 8byte LUNs then. 
> * We can use them as opaque handles. Clean, but resulting in crazy numbers

Actually, I favour this.  Internally we can a structure for the lun. 
All we need to modify are the output routines (setting struct device
bus_id) so that we print it correctly according to LUN type.

>   which sysadmins will hate us for.

Only if the device requests a flat space and then has huge numbers ...
in which case, we're only reporting what the device actually said...

James


