From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Some cosmetic changes to QlogicPTI SCSI driver
Date: Wed, 01 Aug 2007 21:56:37 -0700 (PDT)
Message-ID: <20070801.215637.38712075.davem@davemloft.net>
References: <Pine.LNX.4.61.0707311948370.5707@mtfhpc.demon.co.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0707311948370.5707@mtfhpc.demon.co.uk>
Sender: sparclinux-owner@vger.kernel.org
To: mark@mtfhpc.demon.co.uk
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Date: Tue, 31 Jul 2007 20:10:45 +0100 (BST)

> From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
> 
> Change a printk sequencing issue where <6> ... was coming up in the middle
> of a line when scsi_add_host was being called.
> Reduce the length of some printk messages and make the messages
> more consistant. All cosmetic but it makes it easier to read as it
> scrolles off the screen during boot.
> 
> Signed-off-by: Mark Fortescue <mark@mtfhpc.demon.co.uk>

I'm fine with this:

Signed-off-by: David S. Miller <davem@davemloft.net>

I'll let James take care of merging this.
