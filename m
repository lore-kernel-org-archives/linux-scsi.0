From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi_dh_alua: Add return value and check for
 alua_rtpg_queue() to avoid DM devices I/Os hang
Date: Thu, 1 Dec 2016 10:12:58 -0800
Message-ID: <be5dbac2-6d45-1741-4eed-138aa109477c@sandisk.com>
References: <1479983105-7264-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0049.outbound.protection.outlook.com ([104.47.40.49]:16175
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751993AbcLASNM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Dec 2016 13:13:12 -0500
In-Reply-To: <1479983105-7264-1-git-send-email-tang.junhui@zte.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tang.junhui@zte.com.cn, hare@suse.de, matthew@wil.cx
Cc: linux-scsi@vger.kernel.org, zhang.kai16@zte.com.cn

On 11/24/2016 02:25 AM, tang.junhui@zte.com.cn wrote:
> Activate_complete fn() must be called in alua_activate() if
> alua_rtpg_queue() failed, otherwise, it would cause I/Os hang in DM
> devices. So this patch add return value and check for alua_rtpg_queue().

Hello Tang,

Please drop this patch. I think the alua_rtpg_queue() caller should 
ensure that pg != NULL.

Bart.
