From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH 0/5] target/tcm_fc: Misc. fixups
Date: Sun, 06 Apr 2014 16:08:40 -0700
Message-ID: <1396825720.31010.6.camel@haakon3.risingtidesystems.com>
References: <1396655655-31060-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1396655655-31060-1-git-send-email-agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-04-04 at 16:54 -0700, Andy Grover wrote:
> Hi nab and fcoe developers,
> 
> In fixing the other issue I just posted a patch for, I found some other
> things in the tcm_fc fabric that could be improved. Please take a look?
> 
> Thanks! -- Regards -- Andy
> 
> Andy Grover (5):
>   target/tcm_fc: Don't export ft_lport_list
>   target/tcm_fc: Limit to 1 TPG per wwn
>   target/tcm_fc: Rename structs and list members for clarity
>   target/tcm_fc: Rename ft_{add,del}_lport to {add,del}_wwn
>   target/tcm_fc: Rename ft_tport_create to ft_tport_get
> 
>  drivers/target/tcm_fc/tcm_fc.h   | 12 +++----
>  drivers/target/tcm_fc/tfc_conf.c | 75 ++++++++++++++++++++--------------------
>  drivers/target/tcm_fc/tfc_sess.c |  6 ++--
>  3 files changed, 46 insertions(+), 47 deletions(-)
> 

These all look reasonable.

Applied to target-pending/for-next.

--nab
