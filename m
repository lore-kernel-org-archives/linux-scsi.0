From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.5.31 qlogic error "this should not happen"
Date: Mon, 26 Aug 2002 12:36:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020826123622.A11280@eng2.beaverton.ibm.com>
References: <20020825191854.GA32490@rushmore>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020825191854.GA32490@rushmore>; from rwhron@earthlink.net on Sun, Aug 25, 2002 at 03:18:54PM -0400
List-Id: linux-scsi@vger.kernel.org
To: rwhron@earthlink.net
Cc: ehw@lanl.gov, dledford@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Aug 25, 2002 at 03:18:54PM -0400, rwhron@earthlink.net wrote:
> > I occasionally saw that error on our 2.4 RAID system; it went away when I
> > increased the size of the handles array in qlogicfc.h:
> 
> -#define QLOGICFC_REQ_QUEUE_LEN  127 /* must be power of two - 1 */
> +#define QLOGICFC_REQ_QUEUE_LEN  255 /* must be power of two - 1 */
> 
> That change in addition to Doug's patch in 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=103005703808312&w=2
> have done the trick. 2.5.31-mm1-dl-ew completed the 54 hour
> benchmarathon. (first 2.5 kernel to finish). 
> 
> Details at:
> http://home.earthlink.net/~rwhron/kernel/bigbox.html
> -- 
> Randy Hron

That's a huge amount of data. Can you show cat /proc/scsi/scsi of the machine
(as well as the lspci etc)?

Does RAID-5 mean you have a storage array attached? i.e. IBM 3542, fastt 200?

It looks like the latest qlogic qla driver includes 2.5.x support,
I haven't tried it but will at some time:

http://download.qlogic.com/drivers/5639/qla2x00-v6.1b5-dist.tgz

-- Patrick Mansfield
