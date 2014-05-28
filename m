From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12] scsi/NCR5380: remove redundant HOSTS_C macro tests
Date: Wed, 28 May 2014 02:49:02 -0700
Message-ID: <20140528094902.GB26617@infradead.org>
References: <20140318004212.612472697@telegraphics.com.au>
 <20140318004213.222484138@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140318004213.222484138@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 18, 2014 at 11:42:14AM +1100, Finn Thain wrote:
> HOSTS_C is always undefined. There is no hosts.c anymore.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
