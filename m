From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: Expose shost->max_sectors via sysfs
Date: 28 Oct 2003 13:29:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067372999.7040.56.camel@patehci2>
References: <Pine.LNX.4.44L0.0310281501500.6609-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:18149 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261746AbTJ1UaD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 15:30:03 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310281501500.6609-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: linux-scsi@vger.kernel.org, mdharm-usb@one-eyed-alien.net

> having shost->max_sectors exposed and settable via a sysfs attribute file,
> so ... can be ... high-performance ...

Have we already exposed via sysfs some other part of shost->?

I ask because, if yes, then out of that precedent I could ignorantly try
to construct a concrete candidate patch.

Pat LaVarre


