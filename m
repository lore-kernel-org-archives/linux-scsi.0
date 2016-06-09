From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2] scsi_debug: fix sleep in invalid context
Date: Thu, 9 Jun 2016 09:25:15 -0700
Message-ID: <0eef3f3a-6681-8fde-dcbf-d7f44d502524@sandisk.com>
References: <1464729307-22182-1-git-send-email-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0093.outbound.protection.outlook.com ([65.55.169.93]:30624
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751946AbcFIQZ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2016 12:25:26 -0400
In-Reply-To: <1464729307-22182-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, hch@infradead.org

On 05/31/2016 02:15 PM, Douglas Gilbert wrote:
> In this post: http://www.spinics.net/lists/linux-scsi/msg97124.html
> the author shows some kernel infrastructure complaining about a
> sleep in an invalid context. Remove offending call to vmalloc().
> Instead of using kzalloc() which reviewers didn't like, use a
> bucket system (64 bytes on the stack) and potentially multiple
> calls to sg_pcopy_from_buffer() to construct the 'data-in' buffer
> for the SCSI REPORT LUNS command.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
