From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Why is CONFIG_SCSI_QLA2X_X always enabled?
Date: 22 Apr 2004 12:39:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082651974.1778.52.camel@mulgrave>
References: <4087E95F.5050409@ihateaol.co.uk>
	<20040422092853.55d0b011.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:23271 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264513AbUDVQjm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 12:39:42 -0400
In-Reply-To: <20040422092853.55d0b011.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Kieran <kieran@ihateaol.co.uk>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-22 at 12:28, Randy.Dunlap wrote:
> A nuisance or annoyance perhaps.  Here's a patch for it.

No, it's a variable used to determine whether the user should be asked
about qla2xxx or not.

The proposed patch is obviously not correct, because we don't want the
user to be asked about it.

A better fix might be to make the qla2xxx a menu dependent on SCSI &&
PCI

James


