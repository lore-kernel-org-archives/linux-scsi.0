From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2] [SCSI] scsi_debug: Do not respond to certain commands
 with CHECK CONDITION when sense pending
Date: Fri, 15 Feb 2013 14:37:19 -0500
Message-ID: <511E8E6F.4020208@interlog.com>
References: <1360950751-5136-1-git-send-email-emilne@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:59760 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3BOThd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2013 14:37:33 -0500
In-Reply-To: <1360950751-5136-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 13-02-15 12:52 PM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> According to SPC, certain commands are not supposed to respond
> with a CHECK CONDITION due to a pending UNIT ATTENTION.  This
> was causing failures when re-scanning a scsi_debug target.  The
> commands in this category are INQUIRY and REPORT LUNS.
>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>


