From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/2] esas2r: Replace semaphores with mutexes
Date: Thu, 8 Jun 2017 17:05:50 +0200
Message-ID: <CAK8P3a18y4d1-xQGgkZ+OWwXExO0Qp9Sr8_ZkUAgW2hfG2Y-Mg@mail.gmail.com>
References: <1496916451-6606-1-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496916451-6606-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Binoy Jayan <binoy.jayan@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Rajendra <rnayak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 8, 2017 at 12:07 PM, Binoy Jayan <binoy.jayan@linaro.org> wrote:
> These are a set of patches which removes semaphores from esas2r.
> These are part of a bigger effort to eliminate unwanted semaphores
> from the linux kernel.
>
> Binoy Jayan (2):
>   scsi: esas2r: Replace semaphore fm_api_semaphore with mutex
>   scsi: esas2r: Replace semaphore fs_api_semaphore with mutex

Both conversions looks good. I think the interruption is not handled
correctly here, but your patch doesn't change that.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
