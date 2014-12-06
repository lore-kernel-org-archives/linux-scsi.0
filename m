From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 4/4] scsi_debug: Implement WRITE BUFFER command
Date: Sat, 06 Dec 2014 11:28:15 -0500
Message-ID: <54832E9F.2070106@interlog.com>
References: <1417711768-24167-1-git-send-email-emilne@redhat.com> <1417711768-24167-5-git-send-email-emilne@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53194 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaLFQ2d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Dec 2014 11:28:33 -0500
In-Reply-To: <1417711768-24167-5-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 14-12-04 11:49 AM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> Accept the WRITE BUFFER command and do nothing other than
> set the appropriate "microcode has been changed" UA on the LU.
>
>>From an earlier patch by Doug Gilbert.
>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>


