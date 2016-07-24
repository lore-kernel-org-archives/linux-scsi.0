From: Damien Le Moal <Damien.LeMoal@hgst.com>
Subject: Re: [PATCH 4/6] block: Add 'zoned' sysfs queue attribute
Date: Sun, 24 Jul 2016 23:22:24 +0000
Message-ID: <54A01E4C-1818-4CFD-820C-12F49ECA80C3@hgst.com>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-5-git-send-email-hare@suse.de>
 <yq1wpkd9zbc.fsf@sermon.lab.mkp.net>
 <f39f2a46-75ab-a770-025f-6807c2f14413@suse.de>
 <1dc7f9d7-5a91-b160-7031-8d69ede5567b@sandisk.com>
 <13b63331-f920-0904-b8f7-c3a2ea8270d6@suse.de>
 <836c9ee7-3d1e-7336-342c-ce0efee12422@sandisk.com>
 <65e6de30-4811-969b-6c9e-312104e1ae6a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19327 "EHLO
	esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbcGXXW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jul 2016 19:22:27 -0400
In-Reply-To: <65e6de30-4811-969b-6c9e-312104e1ae6a@sandisk.com>
Content-Language: en-US
Content-ID: <9BBDA11AB8C41F45AC99EACA305C4685@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Bart,


> On Jul 24, 2016, at 22:51, Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> Something I should have asked before: is the zone information intended for end users or rather for software developers? In the latter case, have you considered to use debugfs instead of sysfs to export this information? From Documentation/filesystems/debugfs.txt: "Unlike /proc, which is only meant for information about a process, or sysfs, which has strict one-value-per-file rules, debugfs has no rules at all."

I think that the zone information will definitively be of higher value
for software developers rather than end users. But that information must
be available at run time for things like mkfs.xxx and having to mount
debugfs on a production system to be able to run mkfs on an SMR disk
(or initialize an application using the raw block device) does not sound
ideal.

Back to my previous reply, having the sysfs zoned file specifying just the
disk zone size and having an ioctl to retrieve the detailed zone information
looks to me much more sensible.

Best regards. 

------------------------
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa, 
Kanagawa, 252-0888 Japan
www.hgst.com 

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

