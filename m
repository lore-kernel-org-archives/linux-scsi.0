From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 3/4] scsi_debug: Add REPORTED LUNS DATA HAS CHANGED Unit
 Attention
Date: Sat, 06 Dec 2014 11:28:09 -0500
Message-ID: <54832E99.6030703@interlog.com>
References: <1417711768-24167-1-git-send-email-emilne@redhat.com> <1417711768-24167-4-git-send-email-emilne@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53191 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaLFQ21 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Dec 2014 11:28:27 -0500
In-Reply-To: <1417711768-24167-4-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 14-12-04 11:49 AM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> Generate a REPORTED LUNS DATA HAS CHANGED Unit Attention if
> sysfs "max_luns" is used to change the number of scsi_debug LUNs.
> This is only done if scsi_debug_scsi_level is SPC-3 or above.
> Additionally, implement SPC-4 behavior which only generates
> this Unit Attention on the first LUN on the target to receive
> a command after the change.  This condition is cleared when
> a REPORT LUNS command is received.
>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>

