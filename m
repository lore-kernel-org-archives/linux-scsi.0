From: Craig Tierney <ctierney@hpti.com>
Subject: Re: [HELP] qla2200 driver over 4G memory
Date: Wed, 19 Jun 2002 09:57:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020619095747.M20569@hpti.com>
References: <20020619190228S.miyoshi@hpc.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020619190228S.miyoshi@hpc.bs1.fc.nec.co.jp>; from miyoshi@hpc.bs1.fc.nec.co.jp on Wed, Jun 19, 2002 at 07:02:28PM +0900
List-Id: linux-scsi@vger.kernel.org
To: miyoshi@hpc.bs1.fc.nec.co.jp
Cc: linux-scsi@vger.kernel.org

I haven't had to do this, but did you change the bios
settings on the QLA2200 to allow the card to access
memory above 4GB?  There is an option in there for
this.

Craig

On Wed, Jun 19, 2002 at 07:02:28PM +0900, miyoshi@hpc.bs1.fc.nec.co.jp wrote:
> 
> Hi, all
> 
> I am using QLA2200 on my IA64 box and when I read data to
> the area which strides over 4G boundaries, it seems to read
> the disk data into wrap-around memory area.
> 
> I wrote small test kernel patch and read disk contents to
> physical 0x1ffffc000 to 0x200013fff (0x18000 bytes.)
> It reads first 16K bytes into 0x1ffffc000-0x1ffffffff correctly
> but destroys 0x100000000-0x100013fff.
> 
> I checked the incorrect data contents via kdb, and also
> my printk() in qla2100_64bit_start_scsi() says the address is
> correctly written into request ring, as far as I understood
> the driver code correctly.
> 
> Does anybody have idea?
> 
> Thanks,
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Craig Tierney (ctierney@hpti.com)
