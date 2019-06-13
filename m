From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V2 08/15] staging: unisys: visorhba: use sg helper to
 operate sgl
Date: Thu, 13 Jun 2019 12:16:56 +0200
Message-ID: <20190613101656.GA28256@kroah.com>
References: <20190613071335.5679-1-ming.lei@redhat.com>
 <20190613071335.5679-9-ming.lei@redhat.com>
 <20190613095214.GA18796@kroah.com>
 <20190613100410.GA10829@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20190613100410.GA10829@ming.t460p>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Brian King <brking@us.ibm.com>, Finn Thain <fthain@telegraphics.com.au>, "Juergen E . Fischer" <fischer@norbit.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 13, 2019 at 06:04:11PM +0800, Ming Lei wrote:
> On Thu, Jun 13, 2019 at 11:52:14AM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Jun 13, 2019 at 03:13:28PM +0800, Ming Lei wrote:
> > > The current way isn't safe for chained sgl, so use sg helper to
> > > operate sgl.
> > 
> > I can not make any sense out of this changelog.
> > 
> > What "isn't safe"?  What is a "sgl"?
> 
> sgl is 'scatterlist' in kernel, and several linear sgl can be chained
> together, so accessing the sgl in linear way may see a chained sg, which
> is like a link pointer, then may cause trouble for driver.

What kind of "trouble"?  Is this a bug fix that needs to be backported
to stable kernels?  How can this be triggered?

> > Can this be applied "out of order"?
> 
> Yes, there isn't any dependency among the 15 patches.

Then perhaps you shouldn't send a numbered patch series with different
patches sent to different maintainers, it just causes confusion :)

thanks,

greg k-h
