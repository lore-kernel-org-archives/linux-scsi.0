From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same as
        HBA can_queue value in scsi-mq mode
Date: Thu, 20 Jul 2017 09:47:36 +0200
Message-ID: <20170720074736.GB22218@lst.de>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com> <1499256029-16319-12-git-send-email-shivasharan.srikanteshwara@broadcom.com> <20170711135828.GA12013@lst.de> <3adb43de25a7531af4d083cd1af8c5b5@mail.gmail.com> <1fb5bf7342826f0cf84841930c7c4b11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38013 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933883AbdGTHrh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Jul 2017 03:47:37 -0400
Content-Disposition: inline
In-Reply-To: <1fb5bf7342826f0cf84841930c7c4b11@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com, Kashyap Desai <kashyap.desai@broadcom.com>

I still don't understand why you don't want to do the same for
the non-mq path.
