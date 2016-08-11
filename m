From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] nvme-fabrics: set sqe.command_id in core, not transports
Date: Thu, 11 Aug 2016 14:02:03 -0700
Message-ID: <20160811210203.GB18013@infradead.org>
References: <5792b918.ManFlYqqCmUKB4ry%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbcHKVCE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 17:02:04 -0400
Content-Disposition: inline
In-Reply-To: <5792b918.ManFlYqqCmUKB4ry%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

This needs to cover the loop and PCI driver a swell.
