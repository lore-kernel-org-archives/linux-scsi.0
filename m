From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 00/13]mpt3sas driver NVMe support:
Date: Thu, 29 Jun 2017 16:31:56 +0200
Message-ID: <20170629143156.GR3808@linux-x5ow.site>
References: <1498745954-7907-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753157AbdF2Ob7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jun 2017 10:31:59 -0400
Content-Disposition: inline
In-Reply-To: <1498745954-7907-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com

On Thu, Jun 29, 2017 at 07:49:01PM +0530, Suganath Prabu S wrote:
> Ventura Series controller are Tri-mode. The controller and
> firmware are capable of supporting NVMe devices and
> PCIe switches to be connected with the controller. This
> patch set adds driver level support for NVMe devices and
> PCIe switches.

Hi Suganath,
Can you please also Cc linux-nvme@lists.infradead.org for NVMe related topics.

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
