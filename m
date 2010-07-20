From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 08/16] trivial: use ARRAY_SIZE
Date: Tue, 20 Jul 2010 17:15:56 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1007201715330.4741@pobox.suse.cz>
References: <1277726113-24666-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1277726113-24666-1-git-send-email-segooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Kulikov Vasiliy <segooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kernel Janitors <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "James E.J. Bottomley" <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 28 Jun 2010, Kulikov Vasiliy wrote:

> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/scsi/libfc/fc_exch.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
> index 104e0fb..ca52bfa 100644
> --- a/drivers/scsi/libfc/fc_exch.c
> +++ b/drivers/scsi/libfc/fc_exch.c
> @@ -219,8 +219,6 @@ static void fc_exch_els_rrq(struct fc_seq *, struct fc_frame *);
>   */
>  static char *fc_exch_rctl_names[] = FC_RCTL_NAMES_INIT;
>  
> -#define FC_TABLE_SIZE(x)   (sizeof(x) / sizeof(x[0]))
> -
>  /**
>   * fc_exch_name_lookup() - Lookup name by opcode
>   * @op:	       Opcode to be looked up
> @@ -249,7 +247,7 @@ static inline const char *fc_exch_name_lookup(unsigned int op, char **table,
>  static const char *fc_exch_rctl_name(unsigned int op)
>  {
>  	return fc_exch_name_lookup(op, fc_exch_rctl_names,
> -				   FC_TABLE_SIZE(fc_exch_rctl_names));
> +				   ARRAY_SIZE(fc_exch_rctl_names));
>  }

Applied. Please use better Subject: lines next time though. Having the 
whole series have the same Subject: line doesn't really help.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
