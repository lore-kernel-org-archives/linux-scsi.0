From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same as
        HBA can_queue value in scsi-mq mode
Date: Tue, 11 Jul 2017 15:58:28 +0200
Message-ID: <20170711135828.GA12013@lst.de>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com> <1499256029-16319-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52863 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755945AbdGKN6a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Jul 2017 09:58:30 -0400
Content-Disposition: inline
In-Reply-To: <1499256029-16319-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On Wed, Jul 05, 2017 at 05:00:25AM -0700, Shivasharan S wrote:
> Currently driver sets default queue_depth for VDs at 256 and JBODs based on interface type,
> ie., for SAS JBOD QD will be 64, for SATA JBOD QD will be 32.
> During performance runs with scsi-mq enabled, we are seeing better results by
> setting QD same as HBA queue_depth.

Please no scsi-mq specifics.  just do this unconditionally.
