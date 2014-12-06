From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/4] scsi_debug: Fixed missing "break;" in SDEBUG_UA_CAPACITY_CHANGED
 case
Date: Sat, 06 Dec 2014 11:27:30 -0500
Message-ID: <54832E72.9010105@interlog.com>
References: <1417711768-24167-1-git-send-email-emilne@redhat.com> <1417711768-24167-2-git-send-email-emilne@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53182 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaLFQ1u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Dec 2014 11:27:50 -0500
In-Reply-To: <1417711768-24167-2-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 14-12-04 11:49 AM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> This eliminates a superfluous log message when the capacity is changed:
>
>    "check_readiness: unexpected unit attention code=3"
>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Thanks.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

