From: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/7] scsi-ml: modify change_queue_depth
 to take in reason why it is being called
Date: Wed, 28 Oct 2009 18:43:07 -0700
Message-ID: <1256780587.16472.134.camel@vi2.jf.intel.com>
References: <20091016004639.22451.76363.stgit@vifc.jf.intel.com>
	<1256770118.2989.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1256770118.2989.24.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: christof.schmitt-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-10-28 at 22:48 +0000, James Bottomley wrote:
> On Thu, 2009-10-15 at 17:46 -0700, Vasu Dev wrote:
> This still doesn't build:
> 
> drivers/scsi/53c700.c: In function 'NCR_700_detect':
> drivers/scsi/53c700.c:331: warning: assignment from incompatible pointer type
> drivers/scsi/53c700.c: At top level:
> drivers/scsi/53c700.c:2085: error: conflicting types for 'NCR_700_change_queue_depth'
> drivers/scsi/53c700.c:178: error: previous declaration of 'NCR_700_change_queue_depth' was here
> 

Too bad, I tried "make allmodconfig" again after "make distclean" on
x86_64 but again it didn't catch this error since it didn't compile
53c700.c once again, so any trick to really force all modules
compilation to catch such errors in future ?

> It looks like just an unconverted function prototype, so the patch below fixes it.
> 

Thanks James for the fix and I suppose I don't need to send updated
patch again with your fix since probably you will roll this fix into
this patch when applying this patch.

	Vasu
