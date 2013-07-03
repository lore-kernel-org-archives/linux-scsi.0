From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH v3 0/13] IB SRP initiator patches for kernel 3.11
Date: Wed, 3 Jul 2013 16:38:00 +0300
Message-ID: <51D42938.3010806@mellanox.com>
References: <51D41C03.4020607@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:51248 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837Ab3GCNiR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 09:38:17 -0400
In-Reply-To: <51D41C03.4020607@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@kernel.org>, David Dillow <dave@thedillows.org>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, Jinpu Wang <jinpu.wang@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 03/07/2013 15:41, Bart Van Assche wrote:


[...]

Bart,

> The individual patches in this series are as follows:
> 0001-IB-srp-Fix-remove_one-crash-due-to-resource-exhausti.patch
> 0002-IB-srp-Fix-race-between-srp_queuecommand-and-srp_cla.patch
> 0003-IB-srp-Avoid-that-srp_reset_host-is-skipped-after-a-.patch
> 0004-IB-srp-Fail-I-O-fast-if-target-offline.patch
> 0005-IB-srp-Skip-host-settle-delay.patch
> 0006-IB-srp-Maintain-a-single-connection-per-I_T-nexus.patch
> 0007-IB-srp-Keep-rport-as-long-as-the-IB-transport-layer.patch
> 0008-scsi_transport_srp-Add-transport-layer-error-handlin.patch
> 0009-IB-srp-Add-srp_terminate_io.patch
> 0010-IB-srp-Use-SRP-transport-layer-error-recovery.patch
> 0011-IB-srp-Start-timers-if-a-transport-layer-error-occur.patch
> 0012-IB-srp-Fail-SCSI-commands-silently.patch
> 0013-IB-srp-Make-HCA-completion-vector-configurable.patch
> 0014-IB-srp-Make-transport-layer-retry-count-configurable.patch
> 0015-IB-srp-Bump-driver-version-and-release-date.patch

Some of these patches were already picked by Roland (SB), I would 
suggest that you
post V4 and drop the ones which were accepted.

e8ca413 IB/srp: Bump driver version and release date
4b5e5f4 IB/srp: Make HCA completion vector configurable
96fc248 IB/srp: Maintain a single connection per I_T nexus
99e1c13 IB/srp: Fail I/O fast if target offline
2742c1d IB/srp: Skip host settle delay
086f44f IB/srp: Avoid skipping srp_reset_host() after a transport error
1fe0cb8 IB/srp: Fix remove_one crash due to resource exhaustion

Also, Would help if you use the --cover-letter of git format-patch and
the resulted cover letter  (patch 0/N) as it has standard content which
you can enhance and place your additions.

