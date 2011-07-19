From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] scsi: target: remove custom hex2bin()
	implementation
Date: Mon, 18 Jul 2011 22:11:21 -0700
Message-ID: <1311052281.16756.22.camel@haakon2.linux-iscsi.org>
References: <f051412fa68688dea6d9445d66fbd8085a07bdb7.1310977653.git.andriy.shevchenko@linux.intel.com>
	 <db7c7ad036769bcc0cd737e0b74136a05e57fc85.1310977653.git.andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <db7c7ad036769bcc0cd737e0b74136a05e57fc85.1310977653.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-07-18 at 11:27 +0300, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_cdb.c        |   16 ++++------------
>  drivers/target/target_core_fabric_lib.c |   17 +++++++----------
>  drivers/target/target_core_transport.c  |   28 ----------------------------
>  include/target/target_core_transport.h  |    1 -
>  4 files changed, 11 insertions(+), 51 deletions(-)
> 

Good catch to use proper include/linux/kernel.org:hex2bin() usage
instead of the custom code.

Committed as e270af8 with some minor changes to drop DEV_T10_WWN() macro
usage in favor of direct dereference following v4.1 style.

Thanks!

--nab
