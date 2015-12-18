From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 1/4] scsi: storvsc: Fix a bug in the layout of the
 hv_fc_wwn_packet
Date: Fri, 18 Dec 2015 09:40:58 +0100
Message-ID: <5673C69A.8090800@suse.de>
References: <1450038486-19211-1-git-send-email-kys@microsoft.com>
 <1450038512-19252-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1450038512-19252-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

On 12/13/2015 09:28 PM, K. Y. Srinivasan wrote:
> The hv_fc_wwn_packet is exchanged over vmbus. Make the definition in Linu=
x match
> the Window's definition.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Long Li <longli@microsoft.com>
> Tested-by: Alex Ng <alexng@microsoft.com>
> ---
>   drivers/scsi/storvsc_drv.c |    5 ++---
>   1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index c41f674..00bb4bd 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -92,9 +92,8 @@ enum vstor_packet_operation {
>    */
>
>   struct hv_fc_wwn_packet {
> -	bool	primary_active;
> -	u8	reserved1;
> -	u8	reserved2;
> +	u8	primary_active;
> +	u8	reserved1[3];
>   	u8	primary_port_wwn[8];
>   	u8	primary_node_wwn[8];
>   	u8	secondary_port_wwn[8];
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
