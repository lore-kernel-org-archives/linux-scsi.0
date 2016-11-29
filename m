From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] isci: Add a missing call to pci_unmap_biosrom
Date: Tue, 29 Nov 2016 11:50:40 -0500
Message-ID: <yq1eg1unsbj.fsf@sermon.lab.mkp.net>
References: <20161119174340.20447-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161119174340.20447-1-lambert.quentin@gmail.com> (Quentin
        Lambert's message of "Sat, 19 Nov 2016 18:43:40 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Quentin" == Quentin Lambert <lambert.quentin@gmail.com> writes:

Quentin> Most error branches following the call to pci_map_biosrom
Quentin> contain a call to pci_unmap_biosrom. This patch add these calls
Quentin> where they are missing.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
