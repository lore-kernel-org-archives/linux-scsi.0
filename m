From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: Why is CONFIG_SCSI_QLA2X_X always enabled?
Date: Thu, 22 Apr 2004 10:12:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040422101206.70133b42.rddunlap@osdl.org>
References: <4087E95F.5050409@ihateaol.co.uk>
	<20040422092853.55d0b011.rddunlap@osdl.org>
	<1082651974.1778.52.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:49536 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264584AbUDVRSH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 13:18:07 -0400
In-Reply-To: <1082651974.1778.52.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: kieran@ihateaol.co.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 22 Apr 2004 12:39:34 -0400 James Bottomley wrote:

| On Thu, 2004-04-22 at 12:28, Randy.Dunlap wrote:
| > A nuisance or annoyance perhaps.  Here's a patch for it.
| 
| No, it's a variable used to determine whether the user should be asked
| about qla2xxx or not.

As it is, for some large %age of users (say 99% ?), those 6 qla drivers
show up in the config menu when they aren't needed or wanted.
They get in the way.

| The proposed patch is obviously not correct, because we don't want the
| user to be asked about it.

You want it to always be presented (if PCI && SCSI) ?
No, it should be a selectable option iff PCI && SCSI.

| A better fix might be to make the qla2xxx a menu dependent on SCSI &&
| PCI

It already does.  The problem is that is defaults to the value of
(SCSI && PCI) when a large number of people don't need that
default value.  IOW, it's a bad choice for a default value.

--
~Randy
"We have met the enemy and he is us."  -- Pogo (by Walt Kelly)
