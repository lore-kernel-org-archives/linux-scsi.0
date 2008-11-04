From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET 00/18] open-osd: OSD Initiator library for Linux
Date: Tue, 4 Nov 2008 11:19:23 -0800
Message-ID: <20081104111923.bb19c238.akpm@linux-foundation.org>
References: <48876009.8010701@panasas.com>
	<491073BB.4000900@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <491073BB.4000900@panasas.com>
Sender: linux-next-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, Sami.Iren@seagate.com, pw@padd.com, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 04 Nov 2008 18:09:31 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> Please consider for inclusion, an in-kernel OSD initiator
> library. Its main users are planned to be various OSD based file
> systems and the pNFS-Objects Layout Driver. (To be submitted soon)
>  
> To try out and run the library please visit
> http://open-osd.org and follow the instructions there.
> 
> The submitted patchset is also available via git at:
>    git://git.open-osd.org/linux-open-osd.git osd
>    http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=osd
> 
> Or a compact out-of-tree repository that includes sources 
> and some extras:
>    git://git.open-osd.org/open-osd.git master
>    http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary
> 
> ...
>
> We would like this to sit in -mm tree for a while to make sure it is compilable
> on all platform.

The best way to do that is to include your git tree in linux-next.  If
this code has a probably-will-be-merged-in-2.6.29 status then please
prepare a branch for Stephen to include in the linux-next lineup.
