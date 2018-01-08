From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Mon, 8 Jan 2018 02:05:31 -0800
Message-ID: <20180108100531.GA6967@infradead.org>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58307 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932157AbeAHKFe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 05:05:34 -0500
Content-Disposition: inline
In-Reply-To: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com, linux-nvme@lists.infradead.org, kashyap.desai@broadcom.com

NAK.  Please implement the same ioctl interfaces as the nvme driver
instead of inventing your own incomaptible one.
