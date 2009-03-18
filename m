From: Reinhard Nissl <rnissl@gmx.de>
Subject: Re: [RFC]Redisign Marvell Linux HBA driver Layout.
Date: Wed, 18 Mar 2009 21:24:44 +0100
Message-ID: <49C1588C.60204@gmx.de>
References: <FE3F06125A99254E8D92161AA4569C6F0687C01C@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55206 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751734AbZCRUZB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 16:25:01 -0400
In-Reply-To: <FE3F06125A99254E8D92161AA4569C6F0687C01C@sc-exch02.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ying Chu <jasonchu@marvell.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, jeff@garzik.org, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>, Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>

Hi,

Ying Chu schrieb:

> 2. New Features and Bug-fixes

Is suspend / resume implemented properly in the next release?

I do see here the problem that the system resumes properly, but
my Seagate 10k6 harddrive ST3450856SS 0003 doesn't spin up. A
SATA drive connected to a different controller spins up properly,
so I assume suspend / resume isn't handled properly at the moment.

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de
