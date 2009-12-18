From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Applying MVSAS Patch
Date: Fri, 18 Dec 2009 15:21:35 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0912181519510.23464@uplift.swm.pp.se>
References: <67980649284293627495293095942659870934-Webmail@me.com> <20091216081301.59d1698e.randy.dunlap@oracle.com> <93017718277361587250366956065608636194-Webmail@me.com> <20091216090430.66b7f389.randy.dunlap@oracle.com> <29479280-86A1-4DF5-BA64-F2F0F1A4838B@mac.com>
 <20091216101617.a6499cad.randy.dunlap@oracle.com> <105495033028979535461096937726809251647-Webmail@me.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:37554 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955AbZLROVh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2009 09:21:37 -0500
In-Reply-To: <105495033028979535461096937726809251647-Webmail@me.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Tehonica <matt.tehonica@mac.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ayan@marvell.com" <ayan@marvell.com>

On Fri, 18 Dec 2009, Matthew Tehonica wrote:

> Anyone have any ideas on this??  It compiled fine until I applied those 7 patches.

http://www.spinics.net/lists/linux-ide/msg35614.html

Just remove the last option and it'll compile. The resulting kernel 
doesn't work well for me anyway, instead of oops:ing and working badly, I 
just get kernel freeze.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
