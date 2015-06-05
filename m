From: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 0/3] libfc patches for kernel v4.2
Date: Fri, 05 Jun 2015 14:28:29 -0700
Message-ID: <1433539709.4179.155.camel@lin-nd1-054.jf.intel.com>
References: <20150605212003.6054.15351.stgit@lin-nd1-054.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <20150605212003.6054.15351.stgit-CpQRhGjq1eVJhAXLHP3yBbvm/XP+8Wra@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-06-05 at 14:20 -0700, Vasu Dev wrote:
> These libfc fixes are for kernel 4.2 and with two patches CCed for stable
> kernel also, those two could be picked for current 4.1 cycle now but in case
> too late for current 4.1 then anyway should get picked up by 4.1 stable
> kernel later.
> 
> These patches were posted by Bart Van Assche at open-fcoe.org and then 
> I updated them per discussion on original patches to pick revised patch
> and add related comments at:
> 
> http://lists.open-fcoe.org/pipermail/fcoe-devel/2015-May/012467.html
> 
> 
> Bart Van Assche (3):
>       libfc: Fix fc_fcp_cleanup_each_cmd()
>       libfc: Fix fc_exch_recv_req() error path
>       libfc: Fix a typo in a source code comment
> 
> 
>  drivers/scsi/libfc/fc_exch.c |    8 ++++----
>  drivers/scsi/libfc/fc_fcp.c  |   21 ++++++++++++++++++---
>  2 files changed, 22 insertions(+), 7 deletions(-)
> 

Adding Bart to CC list, I thought stg --auto would CC to original patch
author but that is not the case, sorry for another email for this.


Thanks,
Vasu
