From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] scsi: fc: check for rport presence in fc_block_scsi_eh
Date: Wed, 11 Oct 2017 14:33:46 -0400
Message-ID: <yq1wp41edpx.fsf@oracle.com>
References: <20171010153138.21542-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171010153138.21542-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Tue, 10 Oct 2017 17:31:38 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> Coverity-scan recently found a possible NULL pointer dereference in
> fc_block_scsi_eh() as starget_to_rport() either returns the rport for
> the startget or NULL.
>
> While it is rather unlikely to have fc_block_scsi_eh() called without
> an rport associated it's a good idea to catch potential misuses of the
> API gracefully.

Applied to 4.14/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
