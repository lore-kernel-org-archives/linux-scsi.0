From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: oops reading from Nakamichi SCSI CD changer
Date: Thu, 22 Dec 2005 13:33:48 +0100
Message-ID: <43AA9D2C.3060007@macroscoop.nl>
References: <43A8247C.7000903@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mondriaan.macroscoop.nl ([82.94.9.2]:3565 "EHLO
	mondriaan.macroscoop.nl") by vger.kernel.org with ESMTP
	id S932367AbVLVMdy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 07:33:54 -0500
Received: from rousseau.macroscoop.nl (rousseau.macroscoop.nl [IPv6:2001:888:1734:0:207:e9ff:fe1a:a80c])
	by mondriaan.macroscoop.nl (envelope-from P.Zandbergen@macroscoop.nl) (8.13.4/8.13.4) with ESMTP id jBMCXnB3004062
	for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2005 13:33:49 +0100
Received: from [IPv6:2001:888:1734:0:204:acff:fe25:9469] (appel.macroscoop.nl [IPv6:2001:888:1734:0:204:acff:fe25:9469])
	by rousseau.macroscoop.nl (envelope-from P.Zandbergen@macroscoop.nl) (8.13.4/8.13.4) with ESMTP id jBMCXm7B001032
	for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2005 13:33:49 +0100
In-Reply-To: <43A8247C.7000903@macroscoop.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A couple of days ago, I mailed a bug report with this subject to this list.
When it arrived back, it was caught by spamassassin on our mailserver.
Somehow, the patterns used in the kernel config, dmesg, oops and
/proc/scsi/scsi output triggered spamassassin.

Does that mean that my message does not get to the right people?
Should I resend it with all the details in an attached zip file?

Thanks,
Pim


> Starting with kernel 2.6.13, my system crashes immediately reading from
> one of my two Nakamichi MJ-5.16S SCSI CD changers. For info on this
> device, see http://www.nakamichi.co.jp/download/MJ516S_J.PDF


