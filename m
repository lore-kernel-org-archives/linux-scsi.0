From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: fix failure to probe with scsi_level=1 or 2
 due to NULL devip
Date: Thu, 27 Aug 2015 10:14:20 -0400
Message-ID: <55DF1B3C.3020607@interlog.com>
References: <1440532074-28321-1-git-send-email-emilne@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59008 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbbH0OXY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 10:23:24 -0400
In-Reply-To: <1440532074-28321-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 15-08-25 03:47 PM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> commit cbf67842c3d9 ("scsi_debug: support scsi-mq, queues and locks")
> added a test for devip == NULL in schedule_resp which returned
> SCSI_MLQUEUE_HOST_BUSY.  Unfortunately, if scsi_level 1 or 2 is specified,
> devip will be NULL for the INQUIRY command for the next LUN above the
> configured value and it will be retried indefinitely with an error message.
> Fix this by returning the command in the same context if no devip exists.
>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>


