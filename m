From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] lpfc: add missing Kconfig NVME dependencies
Date: Thu, 23 Feb 2017 02:09:38 -0800
Message-ID: <20170223100938.GA20495@infradead.org>
References: <58adba5f.BoP49Cv2S5zD9ZuD%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53923 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdBWKJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 05:09:43 -0500
Content-Disposition: inline
In-Reply-To: <58adba5f.BoP49Cv2S5zD9ZuD%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: hare@suse.com, martin.petersen@oracle.com, dick.kennedy@broadcom.com, linux-next@vger.kernel.org, sfr@canb.auug.org.au, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On Wed, Feb 22, 2017 at 08:20:47AM -0800, James Smart wrote:
> 
> add missing Kconfig NVME dependencies
> 
> Can't believe I missed posting this

Oh.  I'm not sure everyone is happy having to drag in the whole
nvme and nvme target stack when building lpfc.  Is there a way
to make nvme optional?  And in the future scsi as well?
