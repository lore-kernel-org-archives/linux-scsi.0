From: miyoshi@hpc.bs1.fc.nec.co.jp
Subject: Re: [HELP] qla2200 driver over 4G memory
Date: Thu, 20 Jun 2002 19:20:38 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020620192038J.miyoshi@hpc.bs1.fc.nec.co.jp>
References: <20020619190228S.miyoshi@hpc.bs1.fc.nec.co.jp>
	<20020619095747.M20569@hpti.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020619095747.M20569@hpti.com>
List-Id: linux-scsi@vger.kernel.org
To: ctierney@hpti.com
Cc: linux-scsi@vger.kernel.org


Hi, 

Thanks for your reply.

I enabled "4GB > addressing" on HBA BIOS but it still destroys
wrap-around memory area...

Regards,

> I haven't had to do this, but did you change the bios
> settings on the QLA2200 to allow the card to access
> memory above 4GB?  There is an option in there for
> this.
> 
> Craig
> 
> On Wed, Jun 19, 2002 at 07:02:28PM +0900, miyoshi@hpc.bs1.fc.nec.co.jp wrote:
> > 
> > Hi, all
