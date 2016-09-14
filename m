From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] virtio_scsi: use complete() instead complete_all()
Date: Wed, 14 Sep 2016 00:27:11 -0700
Message-ID: <20160914072711.GC17400@infradead.org>
References: <1473757130-14751-1-git-send-email-wagi@monom.org>
 <1473757130-14751-4-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473757130-14751-4-git-send-email-wagi@monom.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Wagner <wagi@monom.org>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org, Daniel Wagner <daniel.wagner@bmw-carit.de>
List-Id: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
