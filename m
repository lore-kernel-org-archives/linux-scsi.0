From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Qlogic fibre drivers
Date: Tue, 21 May 2002 14:34:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020521143455.A8789@beaverton.ibm.com>
References: <1022006223.7660.11.camel@idoru.hstn.tensor.pgs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1022006223.7660.11.camel@idoru.hstn.tensor.pgs.com>; from derek.richardson@pgs.com on Tue, May 21, 2002 at 01:37:02PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Derek Richardson <derek.richardson@pgs.com>
Cc: linux-scsi@vger.kernel.org

The 6.0B20 driver from the Qlogic site has MPIO_SUPPORT in qla_settings.h
set to 0. I have been running this driver with no MPIO support.

-Mike
Derek Richardson [derek.richardson@pgs.com] wrote:
> All,
> Does anyone have any experiencing using the QLogic fibre drivers? 
> Namely, the v5.x and (newer) 6.x versions.  I'm currently trying to
> _disable_ multipathing/failover capabilities in the version that ships
> w/ RedHat 7.3 (tho. I don't have to use this particular one, just a 5.x
> or later) and having a hard time w/out modifying the driver's source
> code.  Googling and looking at all the notes/docu. doesn't reveal any
> parameters for the module, does anyone know of one?  If not, do you know
> of how to disable it in the source code (yes, that's me being lazy and
> not wanting to dig...).
> Thanks,
> Derek R.

-- 
Michael Anderson
andmike@us.ibm.com

