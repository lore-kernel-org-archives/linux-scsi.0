From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 09/12] scsi_debug: add multiple queue support
Date: Tue, 26 Apr 2016 15:19:20 -0700
Message-ID: <571FE968.2030109@sandisk.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
 <1461600999-28893-10-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0063.outbound.protection.outlook.com ([157.56.110.63]:20770
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752274AbcDZWT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 18:19:26 -0400
In-Reply-To: <1461600999-28893-10-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 04/25/2016 09:16 AM, Douglas Gilbert wrote:
> - * (for response) at one time. Can be reduced by max_queue option. Command
> - * responses are not queued when jdelay=0 and ndelay=0. The per-device
> - * DEF_CMD_PER_LUN can be changed via sysfs:
> - * /sys/class/scsi_device/<h:c:t:l>/device/queue_depth but cannot exceed
> - * SCSI_DEBUG_CANQUEUE. */
> -#define SCSI_DEBUG_CANQUEUE_WORDS  9	/* a WORD is bits in a long */
> + * (for response) per submit queue at one time. Can be reduced by max_queue
> + * option. Command responses are not queued when jdelay=0 and ndelay=0. The
> + * per-device DEF_CMD_PER_LUN can be changed via sysfs:
> + * /sys/class/scsi_device/<h:c:t:l>/device/queue_depth but . */
> +#define SCSI_DEBUG_CANQUEUE_WORDS  3	/* a WORD is bits in a long */
>   #define SCSI_DEBUG_CANQUEUE  (SCSI_DEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
>   #define DEF_CMD_PER_LUN  255

The original comment has the text "but cannot exceed 
SCSI_DEBUG_CANQUEUE". That text has been changed into "but .". Has that 
last part of the comment been changed on purpose?

Bart.
