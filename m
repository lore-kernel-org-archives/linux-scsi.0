From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH-v3 14/14] ib_srpt: Convert to percpu_ida tag allocation
Date: Thu, 4 Feb 2016 14:23:57 -0800
Message-ID: <56B3CF7D.1030903@sandisk.com>
References: <1454137558-30396-1-git-send-email-nab@daterainc.com>
 <1454137558-30396-15-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0083.outbound.protection.outlook.com ([157.56.111.83]:29682
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750784AbcBDWYh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2016 17:24:37 -0500
In-Reply-To: <1454137558-30396-15-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Nicholas Bellinger <nab@linux-iscsi.org>, Vu Pham <vu@mellanox.com>

On 01/29/2016 11:05 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> Cc: Vu Pham <vu@mellanox.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Hello Nic,

A patch description should not only explain what has been changed but 
also why that change is considered useful. That last part is missing 
from the description of this patch. Is the purpose of this patch perhaps 
to improve performance ? If so then you should provide measurement data 
that shows that this patch really improves performance. Personally I 
doubt this patch improves performance because in the ib_srpt driver all 
ioctx allocations happen on the same CPU core, namely the CPU core the 
completion interrupt has been assigned to.

Bart.
