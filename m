From: "Derek Vadala" <derek@cynicism.com>
Subject: Re: Getting HD Serial Numbers in RAID
Date: Tue, 31 Aug 2004 16:26:11 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <45511.129.44.35.24.1093983971.squirrel@cynicism.com>
References: <1093981522.27891.20.camel@afgar.lanl.gov>
Reply-To: derek@cynicism.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaded.cynicism.com ([66.250.54.150]:27553 "EHLO
	jaded.cynicism.com") by vger.kernel.org with ESMTP id S268987AbUHaU2t
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 16:28:49 -0400
In-Reply-To: <1093981522.27891.20.camel@afgar.lanl.gov>
List-Id: linux-scsi@vger.kernel.org
To: aortizjr@lanl.gov
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

> Are there any tools available to get the serial number off the drives in
> the array? Or can I get some pointers on writing such a tool?

You could try smartctl, but I don't know what luck you'll have accessing
the raw devices if they are behind a hardware controller.

http://smartmontools.sourceforge.net/
http://www.linuxjournal.com/article.php?sid=6983



