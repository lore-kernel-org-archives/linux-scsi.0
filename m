From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] scsi_dh_rdac: Add two new SUN devices to
	rdac_dev_list
Date: Mon, 18 Oct 2010 15:38:17 -0700
Message-ID: <1287441497.12759.4.camel@chandra-lucid.beaverton.ibm.com>
References: <B2FD678A64EAAD45B089B123FDFC3ED704BAACC6@inbmail01.lsi.com>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED704BAACC6@inbmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Mon, 2010-10-18 at 14:07 +0530, Chauhan, Vijay wrote:
> This patch adds two new SUN vendor/model in rdac device handlers.
> Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> ---
> --- scsi_dh_rdac.c.orig	2010-10-11 23:23:42.000000000 +0530
> +++ scsi_dh_rdac.c	2010-10-11 23:25:31.000000000 +0530
> @@ -773,6 +773,8 @@ static const struct scsi_dh_devlist rdac
>  	{"ENGENIO", "INF-01-00"},
>  	{"STK", "FLEXLINE 380"},
>  	{"SUN", "CSM100_R_FC"},
> +	{"SUN", "STK6580_6780"},
> +	{"SUN", "SUN_6180"},
>  	{NULL, NULL},
>  };
>  
> --
