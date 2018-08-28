From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 1/2] codafs: Fix build using bare-metal toolchain
Date: Tue, 28 Aug 2018 20:07:30 +0300
Message-ID: <CAHp75Vfa0Hmv+22gC4AZ18r=fehv2eV9wJsvXG+2imsbMdkOHA@mail.gmail.com>
References: <20180828142421.15335-1-semen.protsenko@linaro.org>
 <20180828142421.15335-2-semen.protsenko@linaro.org> <CAHp75VdiRH_J8QUALDNufdWh0eNnKsTmp5q+RGBassFdMcpEmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VdiRH_J8QUALDNufdWh0eNnKsTmp5q+RGBassFdMcpEmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, jaharkes@cs.cmu.edu, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Praneeth Bajjuri <praneeth@ti.com>, paul.sokolovsky@linaro.org, mszeredi@suse.cz, sumit.semwal@linaro.org, Ruslan Bilovol <ruslan.bilovol@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 28, 2018 at 8:03 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:

> P.S. Actually it's the only header which uses KERNEL in UAPI.
> Definitely it should be fixed first.

Okay, it seems I missed __ parts. So, my statement above is wrong.

-- 
With Best Regards,
Andy Shevchenko
