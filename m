From: David Miller <davem@davemloft.net>
Subject: Re: slave_configure for qlogicpti
Date: Sun, 30 Sep 2007 17:29:52 -0700 (PDT)
Message-ID: <20070930.172952.85384131.davem@davemloft.net>
References: <20070919124637.GE7624@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20070919124637.GE7624@parisc-linux.org>
Sender: sparclinux-owner@vger.kernel.org
To: matthew@wil.cx
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Matthew Wilcox <matthew@wil.cx>
Date: Wed, 19 Sep 2007 06:46:37 -0600

> 
> I haven't even compile-tested this.  But look how much ugly code it
> deletes if it works!

It compiles :-)  You deleted the only uses of scsi_rbuf_{get,put}()
so you can kill those off too.

I don't have the time to setup things for testing this patch on
the qlogicpti hardware I have, but with the scsi_rbuf_{get,put}()
deletion added to the patch I would really like to see this go
into 2.6.24 anyways.

If things explode I'll pick up the pieces.

Acked-by: David S. Miller <davem@davemloft.net>
