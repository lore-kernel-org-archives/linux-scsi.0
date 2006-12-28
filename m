From: "Iordan Iordanov" <iordanov@utias.utoronto.ca>
Subject: megaraid driver in linux kernel
Date: Thu, 28 Dec 2006 18:03:18 -0500 (EST)
Message-ID: <41029.142.150.208.10.1167346998.squirrel@arrow.utias.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from arrow.utias.utoronto.ca ([128.100.201.226]:58834 "EHLO
	arrow.utias.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965034AbWL1XNu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Dec 2006 18:13:50 -0500
Received: from arrow.utias.utoronto.ca (localhost [127.0.0.1])
	by arrow.utias.utoronto.ca (8.12.8/8.12.8) with ESMTP id kBSN3IKJ010788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 28 Dec 2006 18:03:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

We are having some trouble with a PERC4/DC card driven by the legacy
megaraid driver on kernel version 2.6.15. It seems as though every once in
a while a few of the drives become corrupt. I read a few places online
people complaining about similar errors (SCSI error: return code =
0x40001).

I also read that the suggestion was to abandon the legacy driver and go
with the new driver.

Well, I compiled kernel 2.6.17 and in my kernel configuration I have the
lines:

CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_SAS=y
CONFIG_MEGARAID_LEGACY=m

I also tried:

CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_SAS=m
CONFIG_MEGARAID_LEGACY=m

In both cases, the card is not detected! Is it that the new megaraid
driver does not support a card as new as the PERC4/DC? Also, is it
possible that it's the legacy driver which is causing the corruption?

Can you please suggest a course of action for us?  I am not subscribed to
the mailing list, so please "cc" me on any replies.

Thank you very much,
Iordan Iordanov,
University of Toronto

-- 
The human mind has a single thread of execution.
