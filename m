From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 00/29] constify scsi pci_device_id.
Date: Mon, 31 Jul 2017 11:27:53 +0200
Message-ID: <20170731092753.GB6417@linux-x5ow.site>
References: <1501403839-8876-1-git-send-email-arvind.yadav.cs@gmail.com>
 <20170731075647.GB4316@linux-x5ow.site>
 <6b6ba203-1352-26ed-8d7e-c14e7bb25d32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6b6ba203-1352-26ed-8d7e-c14e7bb25d32@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, mdr@sgi.com, hare@suse.com, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, yokota@netlab.is.tsukuba.ac.jp, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 31, 2017 at 02:23:11PM +0530, Arvind Yadav wrote:
> Yes, We can add all of them in single patch. But other maintainer wants
> single single patch. thats why I have send 29 patch. :(

Ultimately it's up to Martin and James but I don't see a hughe benefit in
having it all in a separate patch.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
