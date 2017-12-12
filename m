From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: fnic: add a space after %p in printf format
Date: Mon, 11 Dec 2017 21:43:23 -0500
Message-ID: <yq1lgi8r7hw.fsf@oracle.com>
References: <20171210192311.5334-1-nicolas.iooss_linux@m4x.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171210192311.5334-1-nicolas.iooss_linux@m4x.org> (Nicolas
        Iooss's message of "Sun, 10 Dec 2017 20:23:11 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Karan Tilak Kumar <kartilak@cisco.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Nicolas,

> fnic_fcpio_icmnd_cmpl_handler() displays the value of sc with:

> As the literal strings get merged, the function uses %ps instead of the
> intended raw %p format. Fix this by inserting a space.

Applied to 4.16/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
