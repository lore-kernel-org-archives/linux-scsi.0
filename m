From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH v1] Target/iser: Fail SCSI WRITE command if device detected
 integrity error
Date: Tue, 18 Mar 2014 14:55:08 +0200
Message-ID: <5328422C.7030004@mellanox.com>
References: <1395147123-15836-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog125.obsmtp.com ([207.126.144.159]:52522 "EHLO
	eu1sys200aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbaCRM4f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Mar 2014 08:56:35 -0400
In-Reply-To: <1395147123-15836-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org
Cc: target-devel@vger.kernel.org, oren@mellanox.com, linux-scsi@vger.kernel.org

On 18/03/2014 14:52, Sagi Grimberg wrote:
> If during data-transfer a data-integrity error was detected we
> must fail the command with CHECK_CONDITION and not execute
> the command.
>
> Cnages from v0:
> - Added reported-by Or gerlitz
>
> Signed-off-by: Sagi Grimberg<sagig@mellanox.com>
> Reported-by: Or Gerlitz<ogerlitz@mellanox.com>
> ---

s/Cnages/Changes

and put the history below  the --- line, it need not go into the 
upstream change-log
