From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: scsi_sysfs_add_sdev(): uevent emission versus attribute creation
Date: Fri, 22 May 2009 15:02:28 +0200
Message-ID: <4A16A264.60301@s5r6.in-berlin.de>
References: <4A169411.1010600@s5r6.in-berlin.de> <ac3eb2510905220530i46c2e2e5ve8e621953428a92@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57677 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZEVNCe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 09:02:34 -0400
In-Reply-To: <ac3eb2510905220530i46c2e2e5ve8e621953428a92@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-scsi@vger.kernel.org, linux-hotplug@vger.kernel.org

Kay Sievers wrote:
> On Fri, May 22, 2009 at 14:01, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> The sdev's attribute should already be there when
>> the disk's and partitions' symlinks are going to be created.
...
> Maybe it can hook into:
>   BUS_NOTIFY_ADD_DEVICE
> to create the additional attributes?
> 
> That logic is in: drivers/base/core.c : 941.

Yes, this looks good.  I'll give it a try.
-- 
Stefan Richter
-=====-==--= -=-= =-==-
http://arcgraph.de/sr/
