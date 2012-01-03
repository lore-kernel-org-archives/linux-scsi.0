From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] bnx2fc: Reduce object size by consolidating formats
Date: Tue, 03 Jan 2012 10:42:56 -0800
Message-ID: <1325616176.21062.4.camel@joe2Laptop>
References: <fe83ffc5f085b65765262b3c5c74740eb82c9442.1321738492.git.joe@perches.com>
	 <4ECC5097.2050908@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4ECC5097.2050908@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-11-22 at 17:47 -0800, Bhanu Prakash Gollapudi wrote:
> On 11/19/2011 1:35 PM, Joe Perches wrote:
> > Deduplication of formats and consolidating tests
> > makes the object much smaller.
> >
> > Add bnx2fc_debug.c, add functions for a few logging
> > functions (BNX2FC_IO_DBG, BNX2FC_TGT_DBG, BNX2FC_HBA_DBG).
> > Use printf extension %pV.
> > Add and use pr_fmt and pr_<level>.
> > Move the debug #include below structure definitions.
> >
> > $ size drivers/scsi/bnx2fc/built-in.o*
> >     text	   data	    bss	    dec	    hex	filename
> >   101563	   1165	  24976	 127704	  1f2d8	drivers/scsi/bnx2fc/built-in.o.new
> >   138473	   1109	  33400	 172982	  2a3b6	drivers/scsi/bnx2fc/built-in.o.old
> >
> > Signed-off-by: Joe Perches<joe@perches.com>
> Thanks Joe.
> 
> Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Still unmerged after 6 weeks.  What's happening with this?
