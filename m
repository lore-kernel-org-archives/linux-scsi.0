From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Tue, 11 Jul 2006 21:20:30 -0400
Message-ID: <44B44E5E.2040101@torque.net>
References: <20060711232109.GA12249@lsil.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:65171 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932338AbWGLBVG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 21:21:06 -0400
In-Reply-To: <20060711232109.GA12249@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Eric Moore wrote:
> Transport Layer Retry support for SAS Tapes.
> Detects whether firmware supports TLR, then
> issues special scsi opcode to enable TLR in
> the end device.

Eric,
The "protocol specific logical unit mode page for SAS
SSP - short format" has a 'transport layer retries'
bit. I thought that SAS tape drives would implement
that mode page (0x18,0x0) and allow that bit to be
changeable.

The "special scsi opcode to enable TLR" seems to imply
another technique.

Doug Gilbert



