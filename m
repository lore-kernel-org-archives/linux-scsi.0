From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: Re: [PATCH] iscsi-target: return -ENOMEM instead of -1 in case of
 failed kmalloc()
Date: Sun, 15 Nov 2015 01:11:49 +0000
Message-ID: <5647DBD5.7040900@osg.samsung.com>
References: <1445285904-31247-1-git-send-email-luisbg@osg.samsung.com> <1447540273.18527.5.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54672 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbbKOBLy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Nov 2015 20:11:54 -0500
In-Reply-To: <1447540273.18527.5.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, cvubrugier@fastmail.fm, sagig@mellanox.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 14/11/15 22:31, Nicholas A. Bellinger wrote:
> Hi Luis,
> 
> Apologies for the delayed response.
>

No worries. I understand maintainers are very busy.

Thanks for taking the time to review and merge :)

Enjoy your weekend,
Luis

 
> On Mon, 2015-10-19 at 21:18 +0100, Luis de Bethencourt wrote:
>> Smatch complains about returning hard coded error codes, silence this
>> warning.
>>
>> drivers/target/iscsi/iscsi_target_parameters.c:211 iscsi_create_default_params() warn: returning -1 instead of -ENOMEM is sloppy
>>
>> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
>> ---
>>
>> Hi,
>>
>> This doesn't change the functionality. It is just about using the more specific
>> errno. And at the same time silencing smatch.
>>
>> Thanks,
>> Luis
>>
>>  drivers/target/iscsi/iscsi_target_parameters.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
> 
> Applied to target-pending/queue-fixes.
> 
> Thank you,
> 
> --nab
> 
> 

