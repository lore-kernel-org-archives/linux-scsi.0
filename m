From: Joe <joecool1029@gmail.com>
Subject: Re: Empty partition nodes not created (was device node issues with recent mm's and udev)
Date: Tue, 3 May 2005 00:18:05 -0400
Message-ID: <d4757e600505022118131ec083@mail.gmail.com>
References: <d4757e6005050219514ece0c0a@mail.gmail.com>
	 <20050503031421.GA528@kroah.com>
	 <20050502202620.04467bbd.rddunlap@osdl.org>
Reply-To: Joe <joecool1029@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.201]:5527 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261373AbVECESL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 May 2005 00:18:11 -0400
Received: by rproxy.gmail.com with SMTP id a41so1014760rng
        for <linux-scsi@vger.kernel.org>; Mon, 02 May 2005 21:18:07 -0700 (PDT)
In-Reply-To: <20050502202620.04467bbd.rddunlap@osdl.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Greg KH <greg@kroah.com>

On 5/2/05, Randy.Dunlap <rddunlap@osdl.org> wrote:
> Could this 2.6.11.8 -stable patch fix it?
> Subject: [04/07] partitions/msdos.c fix
> 
> Joe, can you test 2.6.11.8, please?
> 
> ---
> ~Randy
> 

Randy, Can't run vanilla at the moment on this setup, any way you can
get the patch seperate?  I also don't think that will fix it because
this is an empty, not a msdos partition.

Thanks,
Joe
