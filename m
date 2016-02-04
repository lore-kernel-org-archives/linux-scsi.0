From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 4/4] qla2xxx: Add DebugFS node to show irq vector's cpuid
Date: Thu, 4 Feb 2016 10:20:03 -0800
Message-ID: <56B39653.6090903@sandisk.com>
References: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
 <1454604319-27947-5-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0064.outbound.protection.outlook.com ([207.46.100.64]:41188
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751883AbcBDSVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2016 13:21:17 -0500
In-Reply-To: <1454604319-27947-5-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, Quinn Tran <quinn.tran@qlogic.com>

On 02/04/2016 08:45 AM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
>
>> cat /sys/kernel/debug/qla2xxx/*/irq_cpuid
> qla2xxx_81
>              IRQ Name  Vector  CPUID
>     qla2xxx (default)  150     9
>       qla2xxx (rsp_q)  151     9
>      qla2xxx (atio_q)  152     9

Hello Quinn and Himanshu,

Do you think it would be possible to generate this information via a 
user-space script from /proc/interrupts and /proc/irq/<n>/smp_affinity?

Thanks,

Bart.
