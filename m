From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] aacraid: don't assign cpu_to_le32(int) to u8
Date: Wed, 7 Nov 2007 17:33:07 +0000
Message-ID: <20071107173307.GB25560@infradead.org>
References: <jefxzqqeha.fsf@sykes.suse.de> <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758986AbXKGRdb@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Andreas Schwab <schwab@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 07, 2007 at 10:58:12AM -0500, Salyzyn, Mark wrote:
> Good point, thanks. The intent of the management applications
> utilization of this AIF report is to observe the LSB of the value of
> integer value in BlinkLED. The actions of the cpu_to_le32 actually
> breaks this and reports the wrong content in swapped architectures.
> 
> This attached follow-up patch is against current scsi-misc-2.6 *after*
> the application of the 'don't assign cpu_to_le32(constant) to u8' patch
> submitted by Stephen Rothwell which has already been taken by the -mm
> tree. Inspection of other areas of the aacraid driver came up blank for
> similar style bugs.

Did anyone run the driver through sparse to see if we have more issues like
this?
