From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Why is CONFIG_SCSI_QLA2X_X always enabled?
Date: 22 Apr 2004 13:28:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082654926.1778.84.camel@mulgrave>
References: <4087E95F.5050409@ihateaol.co.uk>
	<20040422092853.55d0b011.rddunlap@osdl.org>
	<1082651974.1778.52.camel@mulgrave>
	<20040422101206.70133b42.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:34793 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264600AbUDVR2w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 13:28:52 -0400
In-Reply-To: <20040422101206.70133b42.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: kieran@ihateaol.co.uk, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-22 at 13:12, Randy.Dunlap wrote:
> As it is, for some large %age of users (say 99% ?), those 6 qla drivers
> show up in the config menu when they aren't needed or wanted.
> They get in the way.

So you want a "Do you want Qlogic drivers" question followed by the 6
drivers if Y?

I'm less enthused about that.  I know there's precedent for it in the
net drivers, but I've always thought it caused more confusion than it
removed.  Traditionally, in SCSI, we've always presented every possible
driver in our list.

I thought the initial complaint you were trying to fix was the "why does
this show up in my .config one"?

James


