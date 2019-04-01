From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] scsi: add new RDAC LENOVO/DE_Series device
Date: Mon, 01 Apr 2019 13:09:45 +0200
Message-ID: <68a761573403917d302bfd0e23bf422245b3d503.camel@suse.de>
References: <20190330144331.20276-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190330144331.20276-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, DM ML <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2019-03-30 at 15:43 +0100, Xose Vazquez Perez wrote:
> Blacklist "Universal Xport" LUN, it's used for in-band storage array
> management.
> And add it to the rdac dh family.
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: SCSI ML <linux-scsi@vger.kernel.org>
> Cc: DM ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---

Looks good to me. Thanks for taking care of this.

Reviewed-by: Martin Wilck <mwilck@suse.com>


>  drivers/scsi/scsi_devinfo.c | 1 +
>  drivers/scsi/scsi_dh.c      | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c
> b/drivers/scsi/scsi_devinfo.c
> index c4cbfd07b916..a08ff3bd6310 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -238,6 +238,7 @@ static struct {
>  	{"NETAPP", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
>  	{"LSI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
>  	{"ENGENIO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
> +	{"LENOVO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
>  	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN |
> BLIST_INQUIRY_36},
>  	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
>  	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 &
> DDS4 autoloaders */
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index 5a58cbf3a75d..c14006ac98f9 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -75,6 +75,7 @@ static const struct scsi_dh_blist scsi_dh_blist[] =
> {
>  	{"NETAPP", "INF-01-00",		"rdac", },
>  	{"LSI", "INF-01-00",		"rdac", },
>  	{"ENGENIO", "INF-01-00",	"rdac", },
> +	{"LENOVO", "DE_Series",		"rdac", },
>  	{NULL, NULL,			NULL },
>  };
>  
