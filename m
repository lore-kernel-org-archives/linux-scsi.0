From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2] scsi: bfa: add error handling for pci_iomap
Date: Thu, 14 Jun 2018 15:00:30 +0300
Message-ID: <CAHp75VfuHASHEigiy+3-J3+7N2q=1nTyHr1KShkjRO+7COjMrw@mail.gmail.com>
References: <1528705581-34646-1-git-send-email-jiazhouyang09@gmail.com> <1528977459-52285-1-git-send-email-jiazhouyang09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1528977459-52285-1-git-send-email-jiazhouyang09@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhouyang Jia <jiazhouyang09@gmail.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 14, 2018 at 2:57 PM, Zhouyang Jia <jiazhouyang09@gmail.com> wrote:
> When pci_iomap fails, the lack of error-handling code may
> cause unexpected results.

What results?
How had you tested it?

> This patch adds error-handling code after calling pci_iomap.

> +       if (bfad->pci_bar2_kva == NULL) {

> +               printk(KERN_ERR "Fail to map bar2\n");

pr_err() ?

> +               goto out_unmap_bar0;
> +       }

-- 
With Best Regards,
Andy Shevchenko
