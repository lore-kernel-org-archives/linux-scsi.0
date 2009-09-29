From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] drivers/scsi/libsas: Use SAM_GOOD
Date: Tue, 29 Sep 2009 14:12:26 +0000
Message-ID: <1254233546.3942.36.camel@mulgrave.site>
References: <Pine.LNX.4.64.0909290759420.29620@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752707AbZI2OMf@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0909290759420.29620@ask.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: djwong@us.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-09-29 at 08:00 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The field stat->stat should be compared to SAM_GOOD, not SAM_STAT_GOOD, as
> done elsewhere in the same function.  Both constants have the same value.

Actually, I'd like to see us go the other way.  Use the standard SCSI
defined SAM_STAT macros in libsas instead of its hand rolled
equivalents.  This would mean modifying aic94xx/aic94xx_task.c and
libsas.h as well.

Thanks,

James
