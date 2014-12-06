From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 2/4] scsi_debug: Added taking of sdebug_host_list_lock
 when changing capacity
Date: Sat, 06 Dec 2014 11:27:46 -0500
Message-ID: <54832E82.2060002@interlog.com>
References: <1417711768-24167-1-git-send-email-emilne@redhat.com> <1417711768-24167-3-git-send-email-emilne@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53186 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaLFQ2E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Dec 2014 11:28:04 -0500
In-Reply-To: <1417711768-24167-3-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 14-12-04 11:49 AM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> All other traversals of the sdebug_host_list take the lock.
>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Thanks.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

