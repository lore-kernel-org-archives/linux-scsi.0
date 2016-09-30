From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogUmU6IFtQQVRDSF0gc2NzaV9kaF9hbHVhOiBmaXgg?=
 =?UTF-8?Q?meory_leak_in_alua=5frtpg=28=29?=
Date: Thu, 29 Sep 2016 20:10:23 -0700
Message-ID: <ef152915-74e0-c3ec-2b6d-d444f97f7a93@sandisk.com>
References: <1474193111-6396-1-git-send-email-tang.junhui@zte.com.cn>
 <34d91218-a0a4-85aa-2771-025504fb267b@sandisk.com>
 <OF43B9D452.88594DE1-ON4825803E.00040F00-4825803E.0007D1CA@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0056.outbound.protection.outlook.com ([104.47.37.56]:25501
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752787AbcI3DKg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Sep 2016 23:10:36 -0400
In-Reply-To: <OF43B9D452.88594DE1-ON4825803E.00040F00-4825803E.0007D1CA@zte.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "tang.junhui@zte.com.cn" <tang.junhui@zte.com.cn>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "zhang.kai16@zte.com.cn" <zhang.kai16@zte.com.cn>

On 09/29/16 18:25, tang.junhui@zte.com.cn wrote:
> Thank you for your review and reminding, I will resend this patchto
> stable@vger.kernel.org.

Hello Tang Junhui,

Please have a look at Documentation/SubmittingPatches. Patches should 
not be sent directly to stable@vger.kernel.org but instead the line "Cc: 
stable@vger.kernel.org" should be added to a patch. And since Hannes 
wrote this code I would appreciate it if Hannes could comment on this 
patch before it is reposted ...

Thanks,

Bart.
