From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 3/6] scsi_debug: add multiple queue support
Date: Mon, 9 May 2016 15:36:33 -0700
Message-ID: <573110F1.2030305@sandisk.com>
References: <1462509629-24282-1-git-send-email-dgilbert@interlog.com>
 <1462509629-24282-4-git-send-email-dgilbert@interlog.com>
 <5730B6EC.90001@sandisk.com> <57310F93.2000709@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0076.outbound.protection.outlook.com ([157.56.110.76]:19648
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751450AbcEIWgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 May 2016 18:36:38 -0400
In-Reply-To: <57310F93.2000709@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 05/09/2016 03:30 PM, Douglas Gilbert wrote:> The maximum return value 
from the first scnprintf(sdebug_info ...)
> is (sizeof(sdebug_info) - 1)). So strictly speaking the early return
> comparison should be "==" for scnprintf and ">=" for snprintf. Given
> that snprintf is more dangerous then scnprintf (e.g. with repeated
> "k += snprintf(buff + k, buff_len - k, ...)" statements) then I would
> prefer to keep scnprintf and yes, ">=" is overkill but will work.

Thanks for the feedback. I'm fine with the other changes in this patch, 
hence:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
