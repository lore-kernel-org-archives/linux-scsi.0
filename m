From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: correcting incorrect peripheral device type 0x0
Date: Wed, 03 Apr 2019 23:34:09 -0400
Message-ID: <yq1zhp6satq.fsf@oracle.com>
References: <ab8d589f-db76-9a95-1b55-3e906ad89487@free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ab8d589f-db76-9a95-1b55-3e906ad89487@free.fr> (Marc Gonzalez's
        message of "Tue, 2 Apr 2019 17:05:05 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: Martin Petersen <martin.petersen@oracle.com>, Avri Altman <avri.altman@wdc.com>, Alim Akhtar <alim.akhtar@samsung.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Marc,

> scsi 0:0:0:49488: scsi_add_lun: correcting incorrect peripheral device type 0x0 for W-LUN 0x            c150hN

             ^^^^^ Where do these crazy LUN numbers come from? That
             looks like something which needs fixing...

-- 
Martin K. Petersen	Oracle Linux Engineering
