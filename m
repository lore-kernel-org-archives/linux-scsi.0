From: Jonathan Nell <crtrn13@gmail.com>
Subject: Re: scsi traffic sniffing
Date: Wed, 2 Sep 2009 15:05:21 +0300
Message-ID: <48e952f40909020505m7efce7fdif79e4b0b6327f53e@mail.gmail.com>
References: <48e952f40908312312w7765c2a1q3a4f022967735288@mail.gmail.com>
	 <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com>
	 <d364733c0909010340t57499a38y4c0bd949e5ba63a6@mail.gmail.com>
	 <d364733c0909012012s1c75434au6a2230e07af4241c@mail.gmail.com>
	 <48e952f40909012120y1d56bb6bha18330fa3266ed64@mail.gmail.com>
	 <d364733c0909012149sb5f780cia8acdc305535d376@mail.gmail.com>
	 <48e952f40909012348y4c86773am3096a32e3dc25218@mail.gmail.com>
	 <d364733c0909020021v4b6b3b61pa6a387836a7c927d@mail.gmail.com>
	 <48e952f40909020050n4135c37br9d927ab61c8bbd65@mail.gmail.com>
	 <d364733c0909020103m41d6781fjad30be856b5f610c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60222 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZIBMFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 08:05:20 -0400
Received: by bwz19 with SMTP id 19so651954bwz.37
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2009 05:05:21 -0700 (PDT)
In-Reply-To: <d364733c0909020103m41d6781fjad30be856b5f610c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>> Hmmm kills my pc when loaded into my kernel (2.6.30)... What kernel
>> version did you last use this with?
> O, it's my bad. I don't update the codes.
> Pls try the new attached. It works on the =A0RHEL5 2.6.18-128.el5.

Thanks Xie but still causes a system crash unfortunately...

=2E..I think that maybe the easiest way would be to rebuild the kernel
with aptly-placed prink()s.
But where's the best place to dump? I inserted into
scsi_lib.c:scsi_execute() and that does dump commands, but doesn't
seem to give me what I want. Just to clarify, I am running a dvd-drive
firmware update in a vmware VM (windows xp guest). I have the
dvd-drive (/dev/sr1) connected in the VM as a scsi device. I would
like to print out ALL traffic to /dev/sr1 - whether generated in the
VM or not - and i need both the cmds and the data in both directions.
I'm just not familiar with the scsi kernel code and there's quite a
lot of things going on there so if anyone could tell me where the best
place to put my printk()s in the kernel code would be - that would be
great!
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
