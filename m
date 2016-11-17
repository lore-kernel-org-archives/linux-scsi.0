From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: dmx3191d: use module_pci_driver
Date: Wed, 16 Nov 2016 20:44:16 -0500
Message-ID: <yq1poluanin.fsf@sermon.lab.mkp.net>
References: <3c6dc0c2b50e9ade60eb484a2e8e4e6234432ec0.1479278622.git.geliangtang@gmail.com>
        <015ae0a9f5aea965329a6669367ee7a61089ef6b.1479278839.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <015ae0a9f5aea965329a6669367ee7a61089ef6b.1479278839.git.geliangtang@gmail.com>
        (Geliang Tang's message of "Wed, 16 Nov 2016 21:00:58 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Geliang" == Geliang Tang <geliangtang@gmail.com> writes:

Geliang> Use module_pci_driver() helper to simplify the code.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
