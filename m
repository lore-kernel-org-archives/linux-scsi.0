From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] scsi: sim710: fix build warning
Date: Tue, 15 Sep 2015 13:30:00 +0530
Message-ID: <20150915080000.GE9305@sudip-pc>
References: <1441375829-6061-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441375829-6061-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 04, 2015 at 07:40:29PM +0530, Sudip Mukherjee wrote:
> We were getting build warning about:
>  "Section mismatch in reference from the variable sim710_eisa_driver to
>  the function .init.text:sim710_eisa_probe()
>  The variable sim710_eisa_driver references the function __init
>  sim710_eisa_probe()"
> 
> sim710_eisa_probe() was having __init but that was being referenced from
> sim710_eisa_driver.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
A gentle ping.
I still get the build warning while building for i386 allmodconfig with
next-20150915.
Build is at https://travis-ci.org/sudipm-mukherjee/parport/jobs/80365417

regards
sudip
