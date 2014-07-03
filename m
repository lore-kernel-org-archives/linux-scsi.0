From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/5] SRP initiator patches for kernel 3.17
Date: Thu, 03 Jul 2014 16:17:15 +0200
Message-ID: <53B565EB.50301@acm.org>
References: <53B55E55.5040907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:60603 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbaGCORV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 10:17:21 -0400
In-Reply-To: <53B55E55.5040907@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, David Dillow <dave@thedillows.org>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

(CC-ing linux-scsi)

On 07/03/14 15:44, Bart Van Assche wrote:
> This patch series consists of the following five patches, of which three
> are bug fixes and two are performance optimizations:
> 
> 0001-scsi_transport_srp-Fix-fast_io_fail_tmo-dev_loss_tmo.patch
> 0002-IB-srp-Fix-deadlock-between-host-removal-and-multipa.patch
> 0003-IB-srp-Fix-residual-handling.patch
> 0004-IB-srp-Use-P_Key-cache-for-P_Key-lookups.patch
> 0005-IB-srp-Optimize-completion-queue-polling.patch
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

