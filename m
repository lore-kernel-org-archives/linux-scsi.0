From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Broadcom 8603 SAS/SATA driver, rough draft
Date: Sun, 23 Sep 2007 19:33:57 -0400
Message-ID: <46F6F7E5.6040100@garzik.org>
References: <20070923040437.GA30170@havoc.gtf.org> <46F6E1C2.20905@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41831 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbXIWXd7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Sep 2007 19:33:59 -0400
In-Reply-To: <46F6E1C2.20905@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Douglas Gilbert wrote:
> Is the lack of SMP support a driver limitation or is it
> the silicon?

Open question (pending w/ BCM).  It looks like the answer is "silicon 
limitation".


> How about support for wide ports

Open question (w/ BCM).  It looks like the answer is "no support."


> Last question: can the chip run in SCSI target mode?

AFAICT, no.

	Jeff


