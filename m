From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] scsi_devinfo: remove synchronous ALUA for
 NETAPP/RDAC devices
Date: Fri, 11 Nov 2016 17:56:20 +0100
Message-ID: <c0af56a1-6b6d-dfe7-7299-1c107458b509@gmail.com>
References: <20161108193242.3454-1-xose.vazquez@gmail.com>
	<e6686f70-5de7-2618-0ba7-5a7b98eba068@suse.de>
	<BN1PR06MB1521E99DDAD4D921182C97695B90@BN1PR06MB152.namprd06.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BN1PR06MB1521E99DDAD4D921182C97695B90@BN1PR06MB152.namprd06.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "George, Martin" <Martin.George@netapp.com>, Hannes Reinecke <hare@suse.de>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, "Schremmer,
	Steven" <Steve.Schremmer@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>, device-mapper development <dm-devel@redhat.com>, "Stewart,
	Sean" <Sean.Stewart@netapp.com>
List-Id: linux-scsi@vger.kernel.org

On 11/09/2016 08:38 AM, George, Martin wrote:

Drop this one.

> As discussed with Hannes, this is not required for ONTAP's LUN C-Mode
> as well. So the ALUA blacklisting may be removed here as well, and
> not just for NetApp RDAC.

OK, done in v2.

Thank you.

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de] 
> Sent: Wednesday, November 9, 2016 12:20 PM
> To: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Cc: George, Martin <Martin.George@netapp.com>; Stankey, Robert <Robert.Stankey@netapp.com>; Schremmer, Steven <Steve.Schremmer@netapp.com>; Stewart, Sean <Sean.Stewart@netapp.com>; Christophe Varoqui <christophe.varoqui@opensvc.com>; James E . J . Bottomley <jejb@linux.vnet.ibm.com>; Martin K . Petersen <martin.petersen@oracle.com>; SCSI ML <linux-scsi@vger.kernel.org>; device-mapper development <dm-devel@redhat.com>
> Subject: Re: [PATCH] scsi_devinfo: remove synchronous ALUA for NETAPP/RDAC devices
> 
> On 11/08/2016 08:32 PM, Xose Vazquez Perez wrote:
>> NetApp did confirm this is only required for ONTAP(LUN C-Mode).
>>
>> Cc: Martin George <Martin.George@netapp.com>
>> Cc: Robert Stankey <Robert.Stankey@netapp.com>
>> Cc: Steven Schremmer <Steven.Schremmer@netapp.com>
>> Cc: Sean Stewart <Sean.Stewart@netapp.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
>> Cc: Martin K. Petersen <martin.petersen@oracle.com>
>> Cc: SCSI ML <linux-scsi@vger.kernel.org>
>> Cc: device-mapper development <dm-devel@redhat.com>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>  drivers/scsi/scsi_devinfo.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c 
>> index 2464569..1fb7964 100644
>> --- a/drivers/scsi/scsi_devinfo.c
>> +++ b/drivers/scsi/scsi_devinfo.c
>> @@ -221,7 +221,6 @@ static struct {
>>  	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>>  	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
>>  	{"NETAPP", "LUN C-Mode", NULL, BLIST_SYNC_ALUA},
>> -	{"NETAPP", "INF-01-00", NULL, BLIST_SYNC_ALUA},
>>  	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>>  	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>>  	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | 
>> BLIST_SINGLELUN},
>>
> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> 
> Cheers,
> 
> Hannes
> 
