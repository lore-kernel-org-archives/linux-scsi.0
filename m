From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 0/5] SRP initiator patches for kernel 3.17
Date: Thu, 03 Jul 2014 18:06:10 +0300
Message-ID: <53B57162.2090802@dev.mellanox.co.il>
References: <53B55E55.5040907@acm.org> <53B565EB.50301@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54535 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbaGCPGR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 11:06:17 -0400
Received: by mail-wi0-f181.google.com with SMTP id n3so2495356wiv.8
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 08:06:16 -0700 (PDT)
In-Reply-To: <53B565EB.50301@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, David Dillow <dave@thedillows.org>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 7/3/2014 5:17 PM, Bart Van Assche wrote:
>> This patch series consists of the following five patches, of which three
>> are bug fixes and two are performance optimizations:
>>
>> 0001-scsi_transport_srp-Fix-fast_io_fail_tmo-dev_loss_tmo.patch
>> 0002-IB-srp-Fix-deadlock-between-host-removal-and-multipa.patch
>> 0003-IB-srp-Fix-residual-handling.patch
>> 0004-IB-srp-Use-P_Key-cache-for-P_Key-lookups.patch
>> 0005-IB-srp-Optimize-completion-queue-polling.patch
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> .
>>

Hey Bart,

The series looks good,

You can add to the series:
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

Specifically to patches #1, #4, #5 you can add:
Tested-by: Sagi Grimberg <sagig@mellanox.com>

Sagi.
