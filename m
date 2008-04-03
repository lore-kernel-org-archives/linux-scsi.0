From: "Sanjay Gandotra" <sanjay.gandotra@exar.com>
Subject: RE: Help On Adaptec SAS Controller AD-483000
Date: Thu, 3 Apr 2008 10:25:01 -0700
Message-ID: <90500F9127D5CC40BE9D712D8ACCB4860864FC@fre1exch00.hq.exar.com>
References: <90500F9127D5CC40BE9D712D8ACCB4860864F6@fre1exch00.hq.exar.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.exar.com ([204.154.183.12]:37125 "EHLO smtp2.exar.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbYDCRYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 13:24:17 -0400
Content-class: urn:content-classes:message
In-Reply-To: <90500F9127D5CC40BE9D712D8ACCB4860864F6@fre1exch00.hq.exar.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sanjay Gandotra <sanjay.gandotra@exar.com>, linux-scsi@vger.kernel.org


Can anyone please suggest me any SAS raid controller which supports
hooking up SATA Port multiplier? As I mentioned earlier, with Adaptec
SAS Controller AD-483000, when I try to send FIS reset to the SATA Port
Multiplier, I get errors from the Adaptec f/w / driver. The command I
send out is:

1. Send Nop with SRST bit set to port 15
0x27 0xf 0x0 0x0 0x0 0x0 0x0 0xa0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x4

2. Send Nop with SRST bit clear to port 15
0x27 0xf 0x0 0x0 0x0 0x0 0x0 0xa0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0

At this point, I am expecting the Port Multiplier to respond with
signature fis.

But I get errors after first command and subsequent commands don't go
out on the bus.
