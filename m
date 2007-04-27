From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH]: Final ESP driver rewrite
Date: Fri, 27 Apr 2007 01:39:41 -0700 (PDT)
Message-ID: <20070427.013941.41636227.davem@davemloft.net>
References: <Pine.LNX.4.61.0704270956500.506@yvahk01.tjqt.qr>
	<20070427.012436.109059523.davem@davemloft.net>
	<Pine.LNX.4.61.0704271032380.506@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40169
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755477AbXD0Ijd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Apr 2007 04:39:33 -0400
In-Reply-To: <Pine.LNX.4.61.0704271032380.506@yvahk01.tjqt.qr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jengelh@linux01.gwdg.de
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Date: Fri, 27 Apr 2007 10:33:30 +0200 (MEST)

> Well the patch looks like it's done in one commit (rather than two -
> delete+add), but that's probably just because it's the diff over both commits.

I didn't do it in multiple commits, I did it in one.

If I do it in two commits, the driver doesn't exist
at a point in the history and this screws things up
for people trying to bisect who have that hardware.
