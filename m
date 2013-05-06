From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for May 6 (lpfc)
Date: Mon, 06 May 2013 09:14:41 -0700
Message-ID: <5187D6F1.9070103@infradead.org>
References: <20130506144207.c812a0227d7763d26e5fec80@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130506144207.c812a0227d7763d26e5fec80@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, James Smart <james.smart@emulex.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 05/05/13 21:42, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any v3.11 destined work to your linux-next included
> branches until after v3.10-rc1 is released.
> 
> I am receiving a (un)reasonable number of conflicts from there being
> multiple copies of some commits in various trees.   Please clean this up
> and resist the temptataion to rebase your trees on the way to your
> upstream ...
> 
> Changes since 20130506:
> 

on i386:
# CONFIG_CRC_T10DIF is not set


drivers/built-in.o: In function `lpfc_bg_crc':
(.text+0x3cb3c9): undefined reference to `crc_t10dif'




-- 
~Randy
