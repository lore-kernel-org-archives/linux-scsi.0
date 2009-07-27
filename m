From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] cnic: Fix ISCSI_KEVENT_IF_DOWN message handling.
Date: Mon, 27 Jul 2009 11:26:10 -0700 (PDT)
Message-ID: <20090727.112610.226306367.davem@davemloft.net>
References: <1248318115-14214-1-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38376
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751634AbZG0S0D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2009 14:26:03 -0400
In-Reply-To: <1248318115-14214-1-git-send-email-mchan@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mchan@broadcom.com
Cc: James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, netdev@vger.kernel.org, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

From: "Michael Chan" <mchan@broadcom.com>
Date: Wed, 22 Jul 2009 20:01:55 -0700

> When a net device goes down or when the bnx2i driver is unloaded,
> the code was not generating the ISCSI_KEVENT_IF_DOWN message
> properly and this could cause the userspace driver to crash.
> 
> This is fixed by sending the message properly in the shutdown path.
> cnic_uio_stop() is also added to send the message when bnx2i is
> unregistering.
> 
> Signed-off-by: Michael Chan <mchan@broadcom.com>

Applied.
