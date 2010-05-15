From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 8/8] libata: implement on-demand HPA unlocking
Date: Sat, 15 May 2010 15:22:29 -0400
Message-ID: <4BEEF475.5000501@garzik.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org> <1273946974-29131-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49384 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0EOTWc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 May 2010 15:22:32 -0400
In-Reply-To: <1273946974-29131-9-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@davemloft.net, bzolnier@gmail.com

On 05/15/2010 02:09 PM, Tejun Heo wrote:
> Implement ata_scsi_unlock_native_capacity() which will be called
> through SCSI layer when block layer notices that partitions on a
> device extend beyond the end of the device.  It requests EH to unlock
> HPA, waits for completion and returns the current device capacity.
>
> This allows libata to unlock HPA on demand instead of having to decide
> whether to unlock upfront.  Unlocking on demand is safer than
> unlocking by upfront because some BIOSes write private data to the
> area beyond HPA limit.  This was suggested by Ben Hutchings.
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
> Suggested-by: Ben Hutchings<ben@decadent.org.uk>

Acked-by: Jeff Garzik <jgarzik@redhat.com>


