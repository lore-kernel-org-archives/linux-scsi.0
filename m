From: Josip Rodin <joy@entuzijast.net>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Tue, 9 Sep 2008 03:49:19 +0200
Message-ID: <20080909014919.GA13444@orion.carnet.hr>
References: <20080908211331.GC22598@plap4-2.qlogic.org> <20080908.142351.00296600.davem@davemloft.net> <20080908214932.GF22598@plap4-2.qlogic.org> <20080908.160820.20152853.davem@davemloft.net> <20080909013557.GD25591@plap4-2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080909013557.GD25591@plap4-2.qlogic.org>
Sender: sparclinux-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 08, 2008 at 06:35:57PM -0700, Andrew Vasquez wrote:
> Josip, could you try out the following patch which defers enablement
> of RISC interrupts until after scsi_add_host()?

Feh, I was just rebooting one last time as part of the bisection :)
I'll let you know soon.

-- 
     2. That which causes joy or happiness.
