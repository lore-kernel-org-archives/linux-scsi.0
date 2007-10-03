From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Wed, 03 Oct 2007 16:25:20 -0400
Message-ID: <4703FAB0.10702@garzik.org>
References: <983400.77431.qm@web31814.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:45155 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898AbXJCUZ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 16:25:27 -0400
In-Reply-To: <983400.77431.qm@web31814.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Matthew Jacob <lydianconcepts@gmail.com>, Michael Reed <mdr@sgi.com>, James.Smart@emulex.com, linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov wrote:
> What is needed is persistence, regardless of reboots of what OS
> is running on the host CPU/system.  SAS WWNs are properties of
> the SAS target/initiator port, they are not properties of when
> the host system was booted, or what OS is running on it.


As part of the previously described schemes, the admin is certainly 
allowed to choose an option (manual WWN specification) that enables an 
external system of persistance.

But such a system should not be a /requirement/, when all an admin might 
want to do is simply get their card working.

The admin knows whats best for their site, and may choose.

	Jeff


