From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: WWID / SerialNo in sysfs?
Date: 09 Feb 2004 11:37:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076344664.2090.21.camel@mulgrave>
References: <20040209160856.GS3944@tpkurt.garloff.de>
	<1076343628.1804.19.camel@mulgrave>
	<20040209162906.GV3944@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:30608 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265251AbUBIQht (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 11:37:49 -0500
In-Reply-To: <20040209162906.GV3944@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, 2004-02-09 at 11:29, Kurt Garloff wrote:
> The nontrivial thing was always to make the relation sg/sd/... device
> to C:B:T:U tuple. With sysfs it's at least possible to do that in
> a reliable way.

Actually, it should be unnecessary in 2.6; the sd devices accept SG_IO
directly.

James


