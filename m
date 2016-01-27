From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] be2iscsi: add checks for dma mapping errors
Date: Tue, 26 Jan 2016 20:46:21 -0500
Message-ID: <yq1si1jiyky.fsf@sermon.lab.mkp.net>
References: <1452894334-8984-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452894334-8984-1-git-send-email-khoroshilov@ispras.ru> (Alexey
	Khoroshilov's message of "Sat, 16 Jan 2016 00:45:34 +0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>, Ketan Mukadam <ketan.mukadam@avagotech.com>, John Soni Jose <sony.john@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Alexey" == Alexey Khoroshilov <khoroshilov@ispras.ru> writes:

Alexey> hwi_write_buffer() does not check if mapping dma memory succeed.
Alexey> The patch adds the check and failure handling.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
