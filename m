From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] sd: Ignore sync cache failures when not supported
Date: Fri, 5 May 2017 02:02:01 -0700
Message-ID: <20170505090201.GA31209@infradead.org>
References: <1493891010-24258-1-git-send-email-thierry.escande@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493891010-24258-1-git-send-email-thierry.escande@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Normally we'd just pass the scsi_sense_hdr structure in from the
caler if we care about sense data.  Is this something you considered?

Otherwise this looks fine to me.
