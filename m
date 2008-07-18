From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 7/8] scsi_dh: attach to hardware handler from
	dm-mpath
Date: Fri, 18 Jul 2008 01:08:54 +0100
Message-ID: <20080718000854.GV7155@agk.fab.redhat.com>
References: <20080717235245.23056.89788.sendpatchset@chandra-ubuntu>
	<20080717235327.23056.59814.sendpatchset@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080717235327.23056.59814.sendpatchset@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 17, 2008 at 04:53:27PM -0700, Chandra Seetharaman wrote:
> +++ linux-2.6.26-git5/drivers/md/dm-mpath.c
> @@ -147,9 +147,12 @@ static struct priority_group *alloc_prio
>  static void free_pgpaths(struct list_head *pgpaths, struct dm_target *ti)
>  {
>  	struct pgpath *pgpath, *tmp;
> +	struct multipath *m = (struct multipath *) ti->private;
  
> @@ -546,6 +549,7 @@ static struct pgpath *parse_path(struct 
>  {
>  	int r;
>  	struct pgpath *p;
> +	struct multipath *m = (struct multipath *) ti->private;
  
FYI We're not writing explicit casts in cases like that in new dm code.

Alasdair
-- 
agk@redhat.com
