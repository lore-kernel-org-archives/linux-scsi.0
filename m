From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bfa: fix access to bfad_im_port_s
Date: Wed, 29 Nov 2017 00:10:05 -0500
Message-ID: <yq1bmjlhdqq.fsf@oracle.com>
References: <20171128152657.13421-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171128152657.13421-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Tue, 28 Nov 2017 16:26:57 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> Commit 'cd21c605b2cf ("scsi: fc: provide fc_bsg_to_shost() helper")'
> changed access to bfa's 'struct bfad_im_port_s' by using shost_priv()
> instead of shost->hostdata[0].

Applied to 4.15/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
