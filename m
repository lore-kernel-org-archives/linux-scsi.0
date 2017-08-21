From: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 0/4] constify scsi/tty parisc_device_id
Date: Mon, 21 Aug 2017 22:43:39 +0200
Message-ID: <12d14a03-5734-9b97-fff0-f8fe7158ce63@gmx.de>
References: <1503165261-31741-1-git-send-email-arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1503165261-31741-1-git-send-email-arvind.yadav.cs@gmail.com>
Content-Language: en-US
Sender: linux-parisc-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, gregkh@linuxfoundation.org, jslaby@suse.com
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 19.08.2017 19:54, Arvind Yadav wrote:
> parisc_device_id are not supposed to change at runtime. All functions
> working with parisc_device_id provided by <asm/parisc-device.h> work with
> const parisc_device_id. So mark the non-const structs as const.
> 
> Arvind Yadav (4):
>   [PATCH 1/4] scsi: lasi700: constify parisc_device_id
>   [PATCH 2/4] scsi: zalon: constify parisc_device_id
>   [PATCH 3/4] tty: 8250: constify parisc_device_id
>   [PATCH 4/4] tty: mux: constify parisc_device_id

NAK.
Please don't apply.
I have other patches in my tree which will move those consts
into __init sections instead.

Thanks,
Helge

 
>  drivers/scsi/lasi700.c             | 2 +-
>  drivers/scsi/zalon.c               | 2 +-
>  drivers/tty/serial/8250/8250_gsc.c | 4 ++--
>  drivers/tty/serial/mux.c           | 4 ++--
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 

