From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Thu, 25 Mar 2004 23:47:07 +0100
Message-ID: <20040325224706.GE16746@fs.tum.de>
References: <E1B6Izr-0002Ai-00@r063144.stusta.swh.mhn.de> <20040325082949.GA3376@gondor.apana.org.au> <20040325220803.GZ16746@fs.tum.de> <40635DD9.8090809@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <bounce-debian-devel=debian-devel=m.gmane.org@lists.debian.org>
Content-Disposition: inline
In-Reply-To: <40635DD9.8090809@pobox.com>
Resent-Message-ID: <BkgD4C.A.ivE.DG2YAB@murphy>
List-Post: <mailto:debian-devel@lists.debian.org>
List-Help: <mailto:debian-devel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-devel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-devel-request@lists.debian.org?subject=unsubscribe>
List-Archive: <http://lists.debian.org/debian-devel/>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: 239952@bugs.debian.org, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 25, 2004 at 05:31:53PM -0500, Jeff Garzik wrote:
> 
> Well IANAL, but it seems not so cut-n-dried, at least.
> 
> Firmware is a program that executes on another processor, so no linking 
> is taking place at all.  It is analagous to shipping a binary-only 
> program in your initrd, IMO.

My point in this mail was a bit "besides the main firmware discussion":

I was not asking whether it's OK to ship this file in the kernel 
sources, I was asking whether the contents of the file is really under 
the GPL as stated in the header of this file if it contains this binary 
code.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
