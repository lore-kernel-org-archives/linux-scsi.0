From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] scsi: ufs: change msleep to usleep_range
Date: Tue, 16 Jul 2019 22:48:35 -0400
Message-ID: <yq136j5z88s.fsf@oracle.com>
References: <BN7PR08MB5684BBB44FD0E43501558A20DBCF0@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BN7PR08MB5684BBB44FD0E43501558A20DBCF0@BN7PR08MB5684.namprd08.prod.outlook.com>
        (Bean Huo's message of "Mon, 15 Jul 2019 11:21:10 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Evan Green <evgreen@chromium.org>, Stanley Chu <stanley.chu@mediatek.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Bean,

> This patch is to change msleep() to usleep_range() based on
> Documentation/timers/timers-howto.txt. It suggests using
> usleep_range() for small msec(1ms - 20ms) since msleep() will often
> sleep longer than desired value.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
