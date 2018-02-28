From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedi: fix build regression
Date: Tue, 27 Feb 2018 21:19:32 -0500
Message-ID: <yq1woyx500b.fsf@oracle.com>
References: <20180226094422.2607574-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180226094422.2607574-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 26 Feb 2018 10:44:14 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Manish Rangankar <Manish.Rangankar@cavium.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> A bugfix I did caused a build regression in some other randconfig
> builds in a rare combination of options:
>
> In file included from drivers/scsi/qedi/qedi_fw.c:16:
> drivers/scsi/qedi/qedi_gbl.h:26:38: error: array type has incomplete element type 'struct qedi_debugfs_ops'
>  extern const struct qedi_debugfs_ops qedi_debugfs_ops[];
>                                       ^~~~~~~~~~~~~~~~
>
> This removes the useless #ifdef around the declarations in qedi_dbg.h
> to make it always build.

Applied to 4.17/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
