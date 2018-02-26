From: Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH v2] Avoid that ATA error handling can trigger a kernel
 hang or oops
Date: Mon, 26 Feb 2018 12:52:40 +0100
Message-ID: <20180226115238.fasex2mjzpouma4h@lorien.valinor.li>
References: <20180222193020.30276-1-bart.vanassche@wdc.com>
 <20180223164630.6ebe70dc@ncopa-desktop.copa.dup.pw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180223164630.6ebe70dc@ncopa-desktop.copa.dup.pw>
Sender: stable-owner@vger.kernel.org
To: Natanael Copa <ncopa@alpinelinux.org>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Alexandre Oliva <oliva@gnu.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org, Jean-Francois Pirus <jfp@clearfield.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Fri, Feb 23, 2018 at 04:46:30PM +0100, Natanael Copa wrote:
> On Thu, 22 Feb 2018 11:30:20 -0800
> Bart Van Assche <bart.vanassche@wdc.com> wrote:
> 
> > Avoid that the recently introduced call_rcu() call in the SCSI core
> > triggers a double call_rcu() call.
> 
> This patch also prevents my machine from hanging. However, the ATA
> error messages that I previously have had are gone, so I don't know if
> it is because the underlying problem is gone, or if the error messages
> are simply not reported.

For reference, the patch has as well been confirmed to solve the
problem for Jean-Francois Pirus in https://bugs.debian.org/891467
(on top of 4.15.4)

Regards,
Salvatore
