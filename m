From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH-v4 0/5] Fix LUN_RESET active I/O + TMR handling
Date: Sat, 6 Feb 2016 20:19:36 -0800
Message-ID: <56B6C5D8.6070403@sandisk.com>
References: <1454815082-15380-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0098.outbound.protection.outlook.com ([65.55.169.98]:19904
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752199AbcBGETl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Feb 2016 23:19:41 -0500
In-Reply-To: <1454815082-15380-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>Christoph Hellwig <hch@lst.de>

On 02/06/16 19:17, Nicholas A. Bellinger wrote:
> Here is -v4 series to address the set of of LUN_RESET
> active I/O + TMR se_cmd->cmd_kref < 0 bugs as reported
> recently by Quinn & Co.  This can occur during active
> I/O remote port TMR LUN_RESET with multi-port LIO
> configurations.

Hi Nic,

If I understood the purpose of this patch series correctly then this 
patch series is a brave attempt to fix what is also fixed by my patch 
called "target: Make ABORT and LUN RESET handling synchronous". Wouldn't 
it be better to focus on that patch instead of trying to fix the current 
approach in which TMR handling happens from the another context than the 
command processing context ?

Thanks,

Bart.

