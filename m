From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/2] scsi: target: fix typo Assoication -> Association
Date: Mon, 18 Jul 2011 22:08:58 -0700
Message-ID: <1311052138.16756.18.camel@haakon2.linux-iscsi.org>
References: <f051412fa68688dea6d9445d66fbd8085a07bdb7.1310977653.git.andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f051412fa68688dea6d9445d66fbd8085a07bdb7.1310977653.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-07-18 at 11:27 +0300, Andy Shevchenko wrote:
> Additionally this patch brings proper apply of the designator type.
> However, the original code luckily has no bug, because the association
> equals to 0.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> Cc: James Bottomley <jbottomley@parallels.com>
> ---
>  drivers/target/target_core_cdb.c      |   10 +++++-----
>  drivers/target/target_core_configfs.c |    2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 

Committed as 300094f75ab1d into lio-core-2.6.git

Thanks Andy!

--nab
