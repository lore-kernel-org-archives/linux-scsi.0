From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Calling sd_shutdown when in state SDEV_DEL
Date: Wed, 24 Mar 2004 08:46:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040324164639.GA1679@beaverton.ibm.com>
References: <200403241603.23269.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:51604 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263768AbUCXQrO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 11:47:14 -0500
Content-Disposition: inline
In-Reply-To: <200403241603.23269.heiko.carstens@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Heiko Carstens [heiko.carstens@de.ibm.com] wrote:
> The patch below solves the problem, but I'm not sure if this is the right
> way to do it. Also setting the state to SDEV_DEL after calling device_del
> is probably pointless...

One point of setting SDEV_DEL is to reduce future scsi_device_get calls from
incrementing the ref count.

-andmike
--
Michael Anderson
andmike@us.ibm.com

