From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Add support for asynchronous scans to libata
Date: Mon, 11 Dec 2006 10:58:06 -0500
Message-ID: <457D800E.5070908@pobox.com>
References: <20061208211236.GC29763@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47066 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936885AbWLKP6J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Dec 2006 10:58:09 -0500
In-Reply-To: <20061208211236.GC29763@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Matthew Wilcox wrote:
> Some of the drivers (AHCI was mentioned to me as a culprit) take a long
> time to discover all the devices attached to them.  Even for ones which
> are relatively quick, if you put a lot of them in a machine, it will
> take a long time in aggregate.  This can be fixed by adding support for
> asynchronous scsi scans, which causes the time-consuming portions of
> initialisation to take place in threads.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>

The time-consuming portion already takes place in a thread.  Do you mean 
multiple threads?  Or, ATA's scan is in one thread, while work continues 
in other threads?

Patch seems sane, provided that I am educated a bit :)

	Jeff



