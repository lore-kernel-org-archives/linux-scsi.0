From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] aacraid: add missing curly braces
Date: Fri, 18 Mar 2016 15:20:06 -0400
Message-ID: <yq1d1qra909.fsf@sermon.lab.mkp.net>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
	<1457965789-3373916-2-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457965789-3373916-2-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Mon, 14 Mar 2016 15:29:43 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Tomas Henzl <thenzl@redhat.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Fengguang Wu <fengguang.wu@intel.com>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Raghava,

Please review.

Arnd> gcc-6 warns about obviously wrong indentation for newly added code
Arnd> in aac_slave_configure():

https://patchwork.kernel.org/patch/8579681/

-- 
Martin K. Petersen	Oracle Linux Engineering
