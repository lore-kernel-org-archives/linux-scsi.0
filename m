From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: ide-scsi emulation hangs the kernel?
Date: 11 Dec 2003 12:31:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071171063.2868.0.camel@patibmrh9>
References: <1071099386.28943.45.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:14298 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265443AbTLKTbN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2003 14:31:13 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id EF4391BDF
	for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2003 12:31:12 -0700 (MST)
In-Reply-To: <1071099386.28943.45.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> > > Could anybody please tell me what's wrong with
> > > the ide-scsi emulation in 2.4.21?
> ...
> no timeout handling in ide-scsi. And once it
> times out the command gets re-issued with a
> timeout that can go off immediately. This patch
> fixes the problem on my system. It's for 2.4.9 ...

Patch!  Thank you.

> I didn't see the original email, ...

http://marc.theaimsgroup.com/?t=107100962500008
begins with:

http://marc.theaimsgroup.com/?l=linux-scsi&m=107100959521497
List:     linux-scsi
Subject:  ide-scsi emulation hangs the kernel?
From:     Yuri Prushinsky <prushinsky () hotbox ! ru>
Date:     2003-12-09 22:36:44

Pat LaVarre


