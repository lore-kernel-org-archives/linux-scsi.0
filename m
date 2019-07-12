From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: uapi: ufs: Fix SPDX license identifier
Date: Thu, 11 Jul 2019 17:20:15 -0700
Message-ID: <1562890815.2915.13.camel@linux.vnet.ibm.com>
References: <1560346477-13944-1-git-send-email-avri.altman@wdc.com>
         <yq1ef2w9kig.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ef2w9kig.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Avri Altman <avri.altman@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Pedro Sousa <pedrom.sousa@synopsys.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avi Shchislowski <avi.shchislowski@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-07-11 at 20:14 -0400, Martin K. Petersen wrote:
> Avri,
> 
> > added 'WITH Linux-syscall-note' exception, which is the officially
> > assigned exception identifier for the kernel syscall exception.
> > This exception makes it possible to include GPL headers into non
> > GPL code, without confusing license compliance tools.
> 
> I'd like Arnd to ack the license change since he has made changes
> (however mechanical) to the file.

Just to note: this isn't technically a licence change at all.  The
entire kernel is covered by the system call exception and this file is
thus also covered.  It's really a simple tag change to allow tools
which parse uapi header files to recognise from the SPDX tags that this
is a kernel header to which the Linux-syscall-note applies.

James
