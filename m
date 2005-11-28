From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/11]  lpfc 8.1.1 : Add support for more members of the Light Pulse 11xxx (4Gb) family
Date: Mon, 28 Nov 2005 16:51:43 +0000
Message-ID: <20051128165143.GA21804@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4B@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:21394 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751299AbVK1Qvp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:51:45 -0500
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4B@xbl3.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Mon, Nov 28, 2005 at 11:42:12AM -0500, James.Smart@Emulex.Com wrote:
> -	pci_read_config_dword(phba->pcidev, PCI_VENDOR_ID, &id);
> +	pci_read_config_word(phba->pcidev, PCI_DEVICE_ID, &dev_id);

please don't read the pci id directly, alway use pdev->device

