From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v3 3/5] scsi: Move sense handling routines to scsi_common
Date: Mon, 6 Jul 2015 08:25:24 -0700
Message-ID: <559A9DE4.8040101@sandisk.com>
References: <1436188508-1539-1-git-send-email-sagig@mellanox.com>
 <1436188508-1539-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0069.outbound.protection.outlook.com ([65.55.169.69]:43776
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751439AbbGFPZc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 11:25:32 -0400
In-Reply-To: <1436188508-1539-4-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

On 07/06/2015 06:15 AM, Sagi Grimberg wrote:
> Sense data handling is also done in the target stack.
> Hence, move sense handling routines to scsi_common so
> the target will be able to use them as well.
>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
