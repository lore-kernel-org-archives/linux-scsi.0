From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: [PATCH v4] dm: Add Dell MD36xxi controller into
	RDAC	device list
Date: Thu, 15 Jul 2010 09:17:52 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4D036F9EB@cosmail01.lsi.com>
References: <F757EE5C3631ED4DBDFD7709119219FE03BBD8CF4C@AUSX7MCPS302.AMER.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <F757EE5C3631ED4DBDFD7709119219FE03BBD8CF4C@AUSX7MCPS302.AMER.DELL.COM>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

James,  Can you please include this patch in next kernel update..  

Thanks
Babu Moger 

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Yanqing_Liu@Dell.com
> Sent: Wednesday, May 19, 2010 12:32 PM
> To: dm-devel@redhat.com; linux-scsi@vger.kernel.org
> Cc: Charles_Rose@Dell.com
> Subject: [dm-devel] [PATCH v4] dm: Add Dell MD36xxi controller into
> RDAC device list
> 
> Hi all,
> 
> This patch is to add next generation of Dell iSCSI PowerVault
> controller MD36xxi into RDAC device list.
> 
> Thanks,
> Yanqing
> 
> Signed off by: Yanqing Liu <Yanqing_Liu@Dell.com>
> ---
> Index: linux-2.6.34/drivers/scsi/device_handler/scsi_dh_rdac.c
> =======================================================================
> =
> --- linux-2.6.34.orig/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-
> 05-19 09:03:34.000000000 -0400
> +++ linux-2.6.34/drivers/scsi/device_handler/scsi_dh_rdac.c	2010-05-19
> 09:01:06.000000000 -0400
> @@ -768,6 +768,7 @@
>  	{"DELL", "MD3000i"},
>  	{"DELL", "MD32xx"},
>  	{"DELL", "MD32xxi"},
> +	{"DELL", "MD36xxi"},
>  	{"LSI", "INF-01-00"},
>  	{"ENGENIO", "INF-01-00"},
>  	{"STK", "FLEXLINE 380"},
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
