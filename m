From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Mon, 09 Dec 2002 17:33:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <244760000.1039480419@aslan.btc.adaptec.com>
References: <203630000.1039477998@aslan.btc.adaptec.com>
 <20021210001256.A9363@infradead.org>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021210001256.A9363@infradead.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Linus Torvalds <torvalds@transmeta.com>

> On Mon, Dec 09, 2002 at 04:53:18PM -0700, Justin T. Gibbs wrote:
>> http://people.FreeBSD.org/~gibbs/linux/RPM  # RPMs for popular
>> distributions http://people.FreeBSD.org/~gibbs/linux/DUD  # Driver
>> Update Diskettes http://people.FreeBSD.org/~gibbs/linux/SRC  # Source
>> tarballs for 2.4.X and  2.5.x relative to today's
>> 					      bk trees.
> 
> Any chance you could provide patches?

I don't see why they are necessary.  The usual reasons for patches are:

1) To review the changes
   With the exception of Doug Ledford, I doubt that many others bother
   to understand how the aic7xxx drivers work

2) To avoid conflicts with other developers
   Who else is maintaining this driver?  Except for a few minor changes
   to the SCSI Makefile and Kconfig/Config.in file, all of the changes
   are contained within the aic7xxx directory.

3) Because the complete files will only work on a paticular kernel version.
   The drop in files should work in all 2.4.X and 2.5.X kernels until the
   next SCSI mid-layer API change comes down the pipe.

4) Because the patches are smaller.
   The aic79xx driver is all "added" files.  The changes since either
   6.2.4 or 6.2.8 are so large that unified diffs are larger than just
   providing the files wholesale.

5) So that when a new kernel version is released all of the patches stop
   working and I need to regenerate them. 8-)

Of course, I'll happily generate patches against whatever kernel versions
the power that be want me to if it will help a driver update to occur.
6.2.8 is so old that its silly and 2.5.X is still using 6.2.4!  The aic79xx
driver has been out since May and its still not in either 2.4.X or 2.5.X.
The BK generated patchsets I've made in the past didn't seem to help things,
but I'm willing to be proven wrong.

--
Justin
