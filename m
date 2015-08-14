From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH] scsi: Export SCSI Inquiry data to sysfs
Date: Fri, 14 Aug 2015 08:27:39 -0400
Message-ID: <55CDDEBB.1040402@avagotech.com>
References: <1439466608-31577-1-git-send-email-jthumshirn@suse.de>
 <55CD8B64.1080400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:33080 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbbHNM1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2015 08:27:46 -0400
Received: by qkfj126 with SMTP id j126so24866921qkf.0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2015 05:27:45 -0700 (PDT)
In-Reply-To: <55CD8B64.1080400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 8/14/2015 2:32 AM, Hannes Reinecke wrote:
> On 08/13/2015 01:50 PM, Johannes Thumshirn wrote:
>> Export the RAW SCSI Inquiry to sysfs as binfile. This way the data can be
>> used by userlang without the need to have and ioctl or use the sg_inq tool.
>>
> userland!
>

Just be careful. There are conditions where this could be stale 
data....   LUN reconfig on an array that hasn't been rescanned by the 
mid layer yet is such a case.

Any reason you didn't have the sysfs call initiate a lun scan or send an 
inquiry so it's always valid data ?

-- james s
