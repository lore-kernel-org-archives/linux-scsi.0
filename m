From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [v2] scsi: qedi: fix build error without DEBUG_FS
Date: Mon, 06 Mar 2017 22:23:12 -0500
Message-ID: <yq1bmtdlqhr.fsf@oracle.com>
References: <20170302145845.1096307-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170302145845.1096307-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Thu, 2 Mar 2017 15:58:03 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>, Manish Rangankar <manish.rangankar@cavium.com>, Chad Dupuis <chad.dupuis@cavium.com>, Arun Easi <arun.easi@cavium.com>, Saurav Kashyap <saurav.kashyap@cavium.com>, Hannes Reinecke <hare@suse.de>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> Without CONFIG_DEBUG_FS, we run into a link error:

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
