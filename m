From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] iscsi-target: return -ENOMEM instead of -1 in case of
 failed kmalloc()
Date: Tue, 20 Oct 2015 14:41:38 +0300
Message-ID: <56262872.1030302@dev.mellanox.co.il>
References: <1445285904-31247-1-git-send-email-luisbg@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38782 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbbJTLlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2015 07:41:42 -0400
Received: by wicll6 with SMTP id ll6so23998553wic.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2015 04:41:41 -0700 (PDT)
In-Reply-To: <1445285904-31247-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luis de Bethencourt <luisbg@osg.samsung.com>, linux-kernel@vger.kernel.org
Cc: nab@linux-iscsi.org, cvubrugier@fastmail.fm, sagig@mellanox.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 10/19/2015 11:18 PM, Luis de Bethencourt wrote:
> Smatch complains about returning hard coded error codes, silence this
> warning.
>
> drivers/target/iscsi/iscsi_target_parameters.c:211 iscsi_create_default_params() warn: returning -1 instead of -ENOMEM is sloppy
>
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>

Looks good,

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
