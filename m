From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] media/cobalt: use pci_irq_allocate_vectors
Date: Wed, 14 Dec 2016 11:29:13 +0100
Message-ID: <20161214102913.GA30236@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de> <1473600688-24043-7-git-send-email-hch@lst.de> <1c24ae65-067f-52fc-edfa-af2d0e222a19@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40643 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753343AbcLNK3w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Dec 2016 05:29:52 -0500
Content-Disposition: inline
In-Reply-To: <1c24ae65-067f-52fc-edfa-af2d0e222a19@xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Christoph Hellwig <hch@lst.de>, hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Hans,

just checked the current Linux tree and cobalt still uses the old
pci_enable_msi_range call.  Did you queue this patch up for 4.10?
