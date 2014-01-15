From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: [PATCH v3 1/2] Hard disk S3 resume time optimization
Date: Wed, 15 Jan 2014 12:04:58 -0800
Message-ID: <20140115200458.GA24720@linux.intel.com>
References: <20140108005607.GB29556@linux.intel.com>
 <20140111191315.GC3257@mtj.dyndns.org>
 <20140113195544.GA13900@linux.intel.com>
 <20140113203007.GA3480@mtj.dyndns.org>
 <20140115003140.GB15067@linux.intel.com>
 <20140115130104.GC7950@htj.dyndns.org>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140115130104.GC7950@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, rjw@rjwysocki.net
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 15, 2014 at 08:01:04AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 14, 2014 at 04:31:40PM -0800, Todd E Brandt wrote:
> ....
> > Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> > 
> >  drivers/ata/libata-core.c | 32 +++++++++++++++++---------------
> >  1 file changed, 17 insertions(+), 15 deletions(-)
> > 
> > Signed-off-by: Todd Brandt <todd.e.brandt@intel.com>
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> Hmmm?  Duplicate SOBs and there's supposed to be "---" separator
> between patch description and the rest.

It's just an editor mistake, sorry

> 
> > @@ -5326,7 +5326,7 @@ bool ata_link_offline(struct ata_link *link)
> >  #ifdef CONFIG_PM
> >  static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
> >  			       unsigned int action, unsigned int ehi_flags,
> > -			       int *async)
> > +			       bool async, int *async_result)
> 
> Do we still need @async_result?  Only resume is async and resume
> doesn't care about the result.  Suspend is always synchronous and thus
> can just return the result, no?

Good point, will fix, thanks.

> 
> Thanks.
> 
> -- 
> tejun
