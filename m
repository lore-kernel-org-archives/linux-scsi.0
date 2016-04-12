From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] mvsas: Generalize Marvell 9485 in pci_device_id
Date: Mon, 11 Apr 2016 22:14:00 -0400
Message-ID: <yq160vn1slz.fsf@sermon.lab.mkp.net>
References: <1460055145-30467-1-git-send-email-leonid.moiseichuk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460055145-30467-1-git-send-email-leonid.moiseichuk@gmail.com>
	(Leonid Moiseichuk's message of "Thu, 7 Apr 2016 21:52:25 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Leonid Moiseichuk <leonid.moiseichuk@gmail.com>
Cc: jejb@linux.vnet.ibm.com, yuxiangl@marvell.com, Wilfried.Weissmann@gmx.at, dan.j.williams@intel.com, andy.shevchenko@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Leonid" == Leonid Moiseichuk <leonid.moiseichuk@gmail.com> writes:

Leonid> For generic subvendor has sense to use generic subdevice.  If
Leonid> subdevice ID not equal to 0x9480/0x9485 mvsas will be not
Leonid> activated.

Applied to 4.7/scsi-queue.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
