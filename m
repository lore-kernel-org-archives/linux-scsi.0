From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: QLA2200 driver
Date: Thu, 25 Apr 2002 09:30:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020425093037.A13358@beaverton.ibm.com>
References: <3CC7E9E0.5050107@corp.home.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3CC7E9E0.5050107@corp.home.nl>; from ttonino@corp.home.nl on Thu, Apr 25, 2002 at 01:34:56PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Thomas Tonino <ttonino@corp.home.nl>
Cc: linux-scsi@vger.kernel.org

Thomas Tonino [ttonino@corp.home.nl] wrote:
> We're setting up a server with a 14 Seagate Cheetah fibre JBOD attached 
> to a single QLA2200 controller.
> 
> The Qlogic fibre driver in 2.4.18 crashes very quickly in this setup, 
> with the message "qlogicfc0 : no handle slots, this should not happen". 
> This crash happens after writing less than 100GB of data to the JBODs.

I believe this is old issues previously discussed on this list and
documented by the GFS people.
http://marc.theaimsgroup.com/?l=linux-scsi&m=99203965930711&w=2

I believe the problem results for recalculations made in the drivers
queuecommand that adjust the can_queue and sg_tablesize. If I remember
correctly the work around was to increase QLOGICFC_REQ_QUEUE_LEN to a
larger value qlogicfc.h. Which will mask this problem.

-Mike
-- 
Michael Anderson
andmike@us.ibm.com

