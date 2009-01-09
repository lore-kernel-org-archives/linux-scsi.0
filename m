From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH 2/6] fastboot: make scsi probes asynchronous
Date: Fri, 09 Jan 2009 13:17:17 -0500
Message-ID: <496794AD.6040403@rtr.ca>
References: <20090105200959.04a626ac@infradead.org> <20090105201118.5bfa1e36@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:41372 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZAISRT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2009 13:17:19 -0500
In-Reply-To: <20090105201118.5bfa1e36@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, akpm@linux-foundation.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

Arjan van de Ven wrote:
>>From 19617cfb1840abc69cc2fe74433007fc1daa1cb7 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 4 Jan 2009 05:32:28 -0800
> Subject: [PATCH] fastboot: make scsi probes asynchronous
> 
> This patch makes part of the scsi probe (which is mostly device spin up and the
> partition scan) asynchronous. Only the part that runs after getting the device
> number allocated is asynchronous, ensuring that device numbering remains stable.
..

Will this burn up the PSUs in loaded server boxes,
due to all drives spinning-up simultaneously now?

Just curious.
