From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 00/20] SCSI: No longer use Scsi_Cmd typedef
Date: Mon, 09 Nov 2009 10:08:07 +0200
Message-ID: <4AF7CDE7.8030008@panasas.com>
References: <1257711411.4759.105.camel@dbueso-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754316AbZKIIIM@vger.kernel.org>
In-Reply-To: <1257711411.4759.105.camel@dbueso-pc>
Sender: linux-kernel-owner@vger.kernel.org
To: dave@gnu.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/08/2009 10:16 PM, Davidlohr Bueso wrote:
> Plenty of older drivers are still using Scsi_Cmd. The following patches
> remove its use and changes them for "struct scsi_cmnd". There is also no
> need for the drivers/scsi/scsi_typedefs.h file anymore since this only
> contains the typedef for Scsi_Cmd. 
> 
> Thanks,
> Davidlohr
> 
> 
>  drivers/scsi/NCR5380.c       |   72 ++++++++++++++++---------------
>  drivers/scsi/NCR5380.h       |   16 ++++----
>  drivers/scsi/NCR53c406a.c    |    6 +-
>  drivers/scsi/aha152x.c       |   68 +++++++++++++++---------------
>  drivers/scsi/aha1542.c       |   30 +++++++-------
>  drivers/scsi/aha1542.h       |   12 +++---
>  drivers/scsi/aha1740.c       |    8 ++--
>  drivers/scsi/aha1740.h       |    4 +-
>  drivers/scsi/atari_NCR5380.c |   94 +++++++++++++++++++++---------------------
>  drivers/scsi/atari_scsi.c    |   12 +++---
>  drivers/scsi/atari_scsi.h    |    2 +-
>  drivers/scsi/dtc.h           |    6 +-
>  drivers/scsi/fd_mcs.c        |   10 ++--
>  drivers/scsi/g_NCR5380.c     |   10 ++--
>  drivers/scsi/g_NCR5380.h     |    6 +-
>  drivers/scsi/gdth.c          |   66 +++++++++++++++---------------
>  drivers/scsi/gdth.h          |   10 ++--
>  drivers/scsi/gdth_proc.c     |    2 +-
>  drivers/scsi/ibmmca.c        |   28 ++++++------
>  drivers/scsi/in2000.c        |   68 +++++++++++++++---------------
>  drivers/scsi/in2000.h        |   14 +++---
>  drivers/scsi/megaraid.c      |   28 ++++++------
>  drivers/scsi/megaraid.h      |   18 ++++----
>  drivers/scsi/nsp32_debug.c   |    2 +-
>  drivers/scsi/pas16.h         |    6 +-
>  drivers/scsi/scsi.h          |    3 -
>  drivers/scsi/sym53c416.c     |    6 +-
>  drivers/scsi/sym53c416.h     |    4 +-
>  drivers/scsi/wd7000.c        |    2 +-
>  29 files changed, 306 insertions(+), 307 deletions(-)
> 

Thanks for doing this. What a grate relief.

One thing that I'm missing is the actual patch to remove the
scsi_typedefs.h file. Is it still used?

Thanks
Boaz
