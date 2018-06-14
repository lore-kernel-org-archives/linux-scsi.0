From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2] pcmcia: add error handling for pcmcia_enable_device
Date: Thu, 14 Jun 2018 12:39:37 +0300
Message-ID: <CAHp75Vf7tbfR5eN4JN2Dph_2qzA=eU2r3S5BfRLH6=vN1+U6ng@mail.gmail.com>
References: <1528694152-31724-1-git-send-email-jiazhouyang09@gmail.com> <1528968207-48671-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528968207-48671-1-git-send-email-jiazhouyang09@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 14, 2018 at 12:23 PM, Zhouyang Jia <jiazhouyang09@gmail.com> wrote:
> When pcmcia_enable_device fails, the lack of error-handling code may
> cause unexpected results.

What results?
You need to elaborate this.,

> This patch adds error-handling code after calling pcmcia_enable_device.

> +       int ret;
> +
> +       ret = pcmcia_enable_device(link);
> +       if (ret)
> +               return -ENODEV;

And why not to return ret?

-- 
With Best Regards,
Andy Shevchenko
