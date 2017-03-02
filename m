From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: qedi: fix build error without DEBUG_FS
Date: Thu, 2 Mar 2017 15:54:49 +0100
Message-ID: <CAK8P3a1ReQoB6PfxMejP-dBfMQE3kaDx1ium-LmFdN=gskUN1g@mail.gmail.com>
References: <20170302121138.2361420-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170302121138.2361420-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Johannes Thumshirn <jthumshirn@suse.de>, Saurav Kashyap <saurav.kashyap@cavium.com>, Nilesh Javali <nilesh.javali@cavium.com>, Chad Dupuis <chad.dupuis@cavium.com>, Manish Rangankar <manish.rangankar@cavium.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>, Arun Easi <arun.easi@cavium.com>, Hannes Reinecke <hare@suse.de>, Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 2, 2017 at 1:10 PM, Arnd Bergmann <arnd@arndb.de> wrote:

>
> -       QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "do_not_recover=%d\n",
> -                 do_not_recover);
> +       QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "qedi_do_not_recover=%d\n",
> +                 qedi_do_not_recover);

> -       QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "do_not_recover=%d\n",
> -                 do_not_recover);
> +       QEDI_INFO(qedi_dbg, QEDI_LOG_DEBUGFS, "qedi_do_not_recover=%d\n",
> +                 qedi_do_not_recover);
>         return 0;
>  }

> -       { "do_not_recover", qedi_dbg_do_not_recover_ops},
> +       { "qedi_do_not_recover", qedi_dbg_do_not_recover_ops},
>         { "io_trace", NULL },
>         { NULL, NULL }

>
> -       cnt = sprintf(buffer, "do_not_recover=%d\n", do_not_recover);
> +       cnt = sprintf(buffer, "qedi_do_not_recover=%d\n", qedi_do_not_recover);
>         cnt = min_t(int, count, cnt - *ppos);

I just noticed that my search&replace went a little too far, I should not have
touched the instances within strings. Will resend.

     Arnd
