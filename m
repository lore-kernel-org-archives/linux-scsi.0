From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH trivial next 7/9] scsi: Use vsprintf extention %pf with
 builtin_return_address
Date: Tue, 28 Feb 2012 16:07:32 -0500 (EST)
Message-ID: <20120228.160732.236576548660822884.davem@davemloft.net>
References: <cover.1330454853.git.joe@perches.com>
	<aa5a8942edf8a59745a514a099e78eaaae03fe26.1330454853.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <aa5a8942edf8a59745a514a099e78eaaae03fe26.1330454853.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: joe@perches.com
Cc: JBottomley@parallels.com, trivial@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 28 Feb 2012 10:49:36 -0800

> Emit the function name not the address when possible.
> 
> builtin_return_address() gives an address.  When building
> a kernel with CONFIG_KALLSYMS, emit the actual function
> name not the address.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: David S. Miller <davem@davemloft.net>
