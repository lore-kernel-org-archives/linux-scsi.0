From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: oops reading from Nakamichi SCSI CD changer
Date: Wed, 01 Feb 2006 01:30:33 +0100
Message-ID: <43E00129.4050507@macroscoop.nl>
References: <43A8247C.7000903@macroscoop.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pimzand.xs4all.nl ([80.126.240.234]:10927 "EHLO
	rubens.pim.zandbergen.org") by vger.kernel.org with ESMTP
	id S932281AbWBAAak (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 19:30:40 -0500
Received: from [192.168.101.1] (rubens.pim.zandbergen.org [192.168.101.1])
	by rubens.pim.zandbergen.org (envelope-from P.Zandbergen@macroscoop.nl) (8.13.4/8.13.4) with ESMTP id k110UX2E005539
	for <linux-scsi@vger.kernel.org>; Wed, 1 Feb 2006 01:30:33 +0100
In-Reply-To: <43A8247C.7000903@macroscoop.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I wrote:

> Starting with kernel 2.6.13, my system crashes immediately reading from
> one of my two Nakamichi MJ-5.16S SCSI CD changers. 

It appears this bug is related to the Adaptec AHA-3960D HBA. I temporarily
replaced it with an LSI Logic 53C875E based card using the sym53c8xx
driver and all was fine.

Unfortunately, this did not help me, as I need the Adaptec's dual channels.

Pim


