From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.6] ips 2/2: minor fixes
Date: 15 Jan 2004 12:50:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074189041.1867.121.camel@mulgrave>
References: <1074188494.607.20.camel@blackmagic>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:8122 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265163AbUAORup (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jan 2004 12:50:45 -0500
In-Reply-To: <1074188494.607.20.camel@blackmagic>
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <david_jeffery@adaptec.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, 2004-01-15 at 12:41, David Jeffery wrote:
> This patch fixes two minor bugs.  It allows zero length write commands
> through to devices.  It also prevents the writing of any  '\0'
> characters at the end of version numbers to ips's /proc/scsi files.

I'll take this, but you are thinking about converting the driver away
from /proc to sysfs, aren't you?

James


