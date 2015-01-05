From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: block: remove artifical max_hw_sectors cap
Date: Mon, 05 Jan 2015 19:40:57 +0100
Message-ID: <54AADAB9.6060302@profihost.ag>
References: <5497F319.20802@profihost.ag> <20141223082805.GA2303@lst.de> <549FF2DB.4000506@profihost.ag> <20141230113206.GA1461@lst.de> <54A2B37E.2090104@profihost.ag> <20150105171734.GA30028@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:50897 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbAESk2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2015 13:40:28 -0500
In-Reply-To: <20150105171734.GA30028@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Am 05.01.2015 um 18:17 schrieb Christoph Hellwig:
> On Tue, Dec 30, 2014 at 03:15:26PM +0100, Stefan Priebe - Profihost AG wrote:
>>> What is the max_sectors_kb value for them?
>>>
>> # cat /sys/block/sdi/queue/max_sectors_kb
>> 16383
>
> That's odd, it's half of what ATA disks should support.  Is this
> device attached to the HBA or an expander?

No the Board has:
10x SATA3 (6Gbps) via C612 from Intel.

Stefan
