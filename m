From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] esas2r: Replace semaphores with mutexes
Date: Mon, 12 Jun 2017 21:18:02 -0400
Message-ID: <yq18tkwznw5.fsf@oracle.com>
References: <1496916451-6606-1-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496916451-6606-1-git-send-email-binoy.jayan@linaro.org> (Binoy
        Jayan's message of "Thu, 8 Jun 2017 15:37:29 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Rajendra <rnayak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Binoy,

> These are a set of patches which removes semaphores from esas2r.
> These are part of a bigger effort to eliminate unwanted semaphores
> from the linux kernel.

Applied to 4.13/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
