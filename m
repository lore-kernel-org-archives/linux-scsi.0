From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH -next] target: iscsi_target depends on NET
Date: Thu, 28 Jul 2011 13:10:13 -0700
Message-ID: <1311883813.6931.196.camel@haakon2.linux-iscsi.org>
References: <20110728135707.44ae2d79ecdda9b50d73adc9@canb.auug.org.au>
	 <20110728094819.22e19fe9.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110728094819.22e19fe9.rdunlap@xenotime.net>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-07-28 at 09:48 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> iscsi target code uses lots on network interface functions, so it
> should depend on NET.  Fixes many build errors when NET is not enabled:
> 
> ERROR: "kernel_sendmsg" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "in_aton" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "sock_release" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "kernel_listen" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "kernel_setsockopt" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "kernel_recvmsg" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "kernel_accept" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "sock_create" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "kernel_bind" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> ERROR: "in6_pton" [drivers/target/iscsi/iscsi_target_mod.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/target/iscsi/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20110728.orig/drivers/target/iscsi/Kconfig
> +++ linux-next-20110728/drivers/target/iscsi/Kconfig
> @@ -1,5 +1,6 @@
>  config ISCSI_TARGET
>  	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
> +	depends on NET
>  	select CRYPTO
>  	select CRYPTO_CRC32C
>  	select CRYPTO_CRC32C_INTEL if X86

Committed as d52a10d00 and pushed into target-pending.git/for-next.

Thanks Randy!

--nab
