From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: mvsas escalated kernel crash and ata mapping mvsas driver question
Date: Thu, 26 Jan 2017 10:51:32 +0100
Message-ID: <d8615494-756f-0fe9-9969-8e850fc5984d@powercraft.nl>
References: <362cdbe9-3633-499e-9ee4-b1a8afed2e40@powercraft.nl>
 <2d56a20b-628f-d621-6c9b-ba5cdf8bf6a0@powercraft.nl>
 <c9684a81-901d-03ea-e322-c27089c4b204@powercraft.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01.cambriumhosting.nl ([217.19.16.173]:37280 "EHLO
        relay01.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753326AbdAZJvm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 04:51:42 -0500
Received: from relay01.cambriumhosting.nl (localhost [127.0.0.1])
        by relay01.cambriumhosting.nl (Postfix) with ESMTP id A3E745223A
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2017 10:51:38 +0100 (CET)
Received: from yessica.powercraft.nl (ebony.powercraft.nl [84.245.27.193])
        by relay01.cambriumhosting.nl (Postfix) with ESMTP id BFC295220D
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2017 10:51:35 +0100 (CET)
Received: from [IPv6:2a02:58:5:2e00:a9e:1ff:fe32:7cf4] (unknown [IPv6:2a02:58:5:2e00:a9e:1ff:fe32:7cf4])
        by yessica.powercraft.nl (Postfix) with ESMTPSA id 40E71200E5
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2017 10:48:50 +0100 (CET)
In-Reply-To: <c9684a81-901d-03ea-e322-c27089c4b204@powercraft.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello everybody,

I got a server that seemingly random gets kernel crashes, due to an 
escalation of events from most likely the mvsas based disk controller.

The harddisk should be okay, I replaced a whole bunch to be sure, but 
the server does not get stable. I can not seem to figure out how to map 
for example ata21.00 to an disk so I can do a deep badblock check.

I have to complete boot with kernel crash log saved with additional 
information.

http://paste.debian.net/plainh/96325d89

Can somebody take a look and maybe help?


08:00.0 SCSI storage controller: Areca Technology Corp. ARC-1300ix-16 
16-Port PCI-Express to SAS Non-RAID Host Adapter (rev 02)

Kind regards,

Jelle de Jong
