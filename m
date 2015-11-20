From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hpsa: select CONFIG_SCSI_SAS_ATTR
Date: Fri, 20 Nov 2015 11:42:36 -0500
Message-ID: <yq1r3jkmxkz.fsf@sermon.lab.mkp.net>
References: <3970646.5sOyETUiWo@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3970646.5sOyETUiWo@wuerfel> (Arnd Bergmann's message of "Thu, 19
	Nov 2015 23:04:35 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> The hpsa driver recently started using the sas transport class,
Arnd> but it does not ensure that the corresponding code is actually
Arnd> built, which may lead to a link error:

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
