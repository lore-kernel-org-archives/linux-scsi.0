From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: [2.4 patch] fix link error with both megaraid drivers
Date: Tue, 11 Nov 2003 23:53:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031111225310.GC13643@fs.tum.de>
References: <20031110174455.GN22185@fs.tum.de> <Pine.LNX.4.44.0311101617530.2001-100000@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:38337 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S263794AbTKKWxT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2003 17:53:19 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311101617530.2001-100000@logos.cnet>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, linux-scsi@vger.kernel.org

On Mon, Nov 10, 2003 at 04:18:16PM -0200, Marcelo Tosatti wrote:
> 
> Just dont compile both drivers at the same time?

IMHO, ideally every valid .config you get through a "make *config" 
should compile.

Compile errors with valid .config's give a wrong impression of the 
stability of the Linux kernel.

I know it's impossible to make configuring the kernel 100% idiot proof, 
but when it's easy to avoid a pitfall many users might observe I think 
it really should be expressed in the Config.in files.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

