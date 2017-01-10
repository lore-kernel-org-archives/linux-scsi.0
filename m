From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: qla2xxx: silent -Wformat-security warning
Date: Mon, 09 Jan 2017 23:21:38 -0500
Message-ID: <yq1a8azee99.fsf@oracle.com>
References: <20161226132310.3204-1-nicolas.iooss_linux@m4x.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161226132310.3204-1-nicolas.iooss_linux@m4x.org> (Nicolas
        Iooss's message of "Mon, 26 Dec 2016 14:23:09 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Nicolas" == Nicolas Iooss <nicolas.iooss_linux@m4x.org> writes:

Nicolas> qla24xx_enable_msix() calls scnprintf() with a non-literal
Nicolas> format string. This makes clang report -Wformat-security
Nicolas> warnings when compiling this function:

Applied 1+2 to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
