From: Vincent Legoll <vincent.legoll@gmail.com>
Subject: Re: [PATCH] Make "SCSI Transports" a menuconfig to ease disabling it all
Date: Tue, 4 Jul 2017 12:53:16 +0200
Message-ID: <CAEwRq=rAASsc_DeusWMe=CzCcTJUH5JAd_MxCW29CS9Kj73FQw@mail.gmail.com>
References: <1499010835-6858-1-git-send-email-vincent.legoll@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499010835-6858-1-git-send-email-vincent.legoll@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel ML <linux-kernel@vger.kernel.org>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Vincent Legoll <vincent.legoll@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Sun, Jul 2, 2017 at 5:53 PM, Vincent Legoll <vincent.legoll@gmail.com> wrote:
> No need to get into the submenu to disable all SCSI Transports-related
> config entries
>
> Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
> ---
>  drivers/scsi/Kconfig | 7 +++++--

Please drop that patch, it will need to be fixed & tested more before resend

-- 
Vincent Legoll
