From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] target: improve unsupported opcode message
Date: Thu, 23 Jul 2015 12:57:07 +0300
Message-ID: <55B0BA73.8010402@dev.mellanox.co.il>
References: <1437602500-3793-1-git-send-email-sbaugh@catern.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36565 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbbGWJ5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2015 05:57:08 -0400
Received: by wicgb10 with SMTP id gb10so135190819wic.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2015 02:57:07 -0700 (PDT)
In-Reply-To: <1437602500-3793-1-git-send-email-sbaugh@catern.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Spencer Baugh <sbaugh@catern.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>

On 7/23/2015 1:01 AM, Spencer Baugh wrote:
> From: Joern Engel <joern@purestorage.com>
>
> Make the warning about unsupported SCSI opcode more useful:
>
>   - Add in the initiator name so we know who's sending it.
>   - Print the warning even for opcodes that spc_parse_cdb() knows about
>     but that we don't handle.
>
> Signed-off-by: Joern Engel <joern@purestorage.com>
> Signed-off-by: Spencer Baugh <sbaugh@catern.com>

Looks good,

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
