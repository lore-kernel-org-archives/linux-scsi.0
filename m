From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/5] arm: implement flush_kernel_dcache_page()
Date: Sat, 03 Jun 2006 23:45:17 -0700 (PDT)
Message-ID: <20060603.234517.104035250.davem@davemloft.net>
References: <1149392479501-git-send-email-htejun@gmail.com>
	<1149392479281-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1149392479281-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: htejun@gmail.com
Cc: axboe@suse.de, James.Bottomley@SteelEye.com, davem@redhat.com, bzolnier@gmail.com, james.steward@dynamicratings.com, jgarzik@pobox.com, mattjreimer@gmail.com, g.liakhovetski@gmx.de, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>
Date: Sun, 4 Jun 2006 12:41:19 +0900

>  arch/sparc64/kernel/head.S            |   30 -------------------
>  arch/sparc64/kernel/setup.c           |   23 ++++++++-------
>  arch/sparc64/kernel/smp.c             |   16 ++++++++--

You're reverting a totally unrelated sparc64 bug fix
in Linus's tree.

Be careful in how you generate your patches.

Thanks :)
