From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Fix cache_type_store()
Date: Thu, 03 Jan 2019 23:37:17 -0500
Message-ID: <yq1muoh82de.fsf@oracle.com>
References: <20181223074158.22796-1-mironov.ivan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181223074158.22796-1-mironov.ivan@gmail.com> (Ivan Mironov's
        message of "Sun, 23 Dec 2018 12:41:58 +0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Ivan Mironov <mironov.ivan@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org


Ivan,

> +	 *     The write protect (WP) bit for mode data sent with a MODE SELECT
> +	 *     command shall be ignored by the device server.
> +	 *     ...
> +	 *     The DPOFUA bit is reserved for mode data sent with a MODE SELECT
> +	 *     command.

Wonderfully consistent :(

Applied to 4.21/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
