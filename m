From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: [2.6.1-bk2] Might sleep while loading st.ko
Date: Tue, 20 Jan 2004 11:42:38 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040120194238.GF23765@srv-lnx2600.matchmail.com>
References: <20040120000725.GY1748@srv-lnx2600.matchmail.com> <Pine.LNX.4.58.0401202121070.1073@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0401202121070.1073@kai.makisara.local>
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 20, 2004 at 09:30:57PM +0200, Kai Makisara wrote:
> Added linux-scsi which may be better list for this problem.
> 
[snip]
> I thought I used enough debugging options to catch this but I did not...
> 
> The patch below fixes this problem (introduced in 2.6.1) by moving cdev 
> code outside the lock protecting st internal data. The patched driver 
> compiles and seems to work in my tests.
> 
> The sysfs link to /sys/cdev/major/st?m0 is not made any more because I have
> understood that it is a bad idea.
> 
> Thanks for reporting the bug.
> 

I'll put this patch in my next kernel compile.

Thanks.
