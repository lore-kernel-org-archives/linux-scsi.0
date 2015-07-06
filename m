From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: Add ALUA state change UA handling
Date: Mon, 6 Jul 2015 08:22:30 -0700
Message-ID: <559A9D36.80503@sandisk.com>
References: <1436182913-85904-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0071.outbound.protection.outlook.com ([65.55.169.71]:40449
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752847AbbGFPWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 11:22:35 -0400
In-Reply-To: <1436182913-85904-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 07/06/2015 04:41 AM, Hannes Reinecke wrote:
> Log the ALUA state change unit attention correctly with
> the message log and emit an event to allow user-space
> tools to react to it.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
