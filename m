From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 06/17] scsi_dh_alua: use flag for RTPG extended header
Date: Thu, 7 May 2015 13:52:23 +0200
Message-ID: <554B51F7.70701@sandisk.com>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
 <1430743343-47174-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0095.outbound.protection.outlook.com ([65.55.169.95]:52392
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751948AbbEGLw3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 07:52:29 -0400
In-Reply-To: <1430743343-47174-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/04/15 14:42, Hannes Reinecke wrote:
> We should be using a flag when RTPG extended header is not
> supported, that saves us sending RTPG twice for older arrays.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

