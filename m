From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] scsi/ibmvscsi: /sys/class/scsi_host/hostX/config
 doesn't show any information
Date: Mon, 30 Jul 2012 10:20:13 +1000
Message-ID: <1343607613.21647.9.camel@pasglop>
References: <1342630157-16468-1-git-send-email-olaf@aepfle.de>
	 <1343366362.2118.15.camel@pasglop> <1343372206.3323.24.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:53853 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab2G3AUq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jul 2012 20:20:46 -0400
In-Reply-To: <1343372206.3323.24.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: olaf@aepfle.de, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, Linda Xie <lxiep@us.ibm.com>

On Fri, 2012-07-27 at 07:56 +0100, James Bottomley wrote:
> On Fri, 2012-07-27 at 15:19 +1000, Benjamin Herrenschmidt wrote:
> > On Wed, 2012-07-18 at 18:49 +0200, olaf@aepfle.de wrote:
> > > From: Linda Xie <lxiep@us.ibm.com>
> > 
> > James, can I assume you're picking up those two ?
> 
> If they get acked by the maintiners ...

I don't think we have a specific upstream maintainer for those drivers,
so let's assume it's my job... NAK on the sysfs one, the other one is
ok, I'll reply to the respective patches.

Cheers,
Ben.


