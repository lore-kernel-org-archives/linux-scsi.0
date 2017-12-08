From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: pmcraid: use correct size unit when calling find_first_zero_bit()
Date: Thu, 07 Dec 2017 21:22:54 -0500
Message-ID: <yq1o9naufep.fsf@oracle.com>
References: <20171116173806.18378-1-niklas.cassel@axis.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171116173806.18378-1-niklas.cassel@axis.com> (Niklas Cassel's
        message of "Thu, 16 Nov 2017 18:38:06 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Niklas Cassel <niklas.cassel@axis.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Niklas Cassel <niklass@axis.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Niklas,

> find_first_zero_bit()'s parameter 'size' is defined in bits,
> not in bytes.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
