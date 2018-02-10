From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: scsi_debug: Fix pointer stying issues
Date: Fri, 9 Feb 2018 21:53:43 -0500
Message-ID: <8afe5abe-9aba-de0b-bbe6-f6e98dbccdee@interlog.com>
References: <1518228763-12937-1-git-send-email-jpittman@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39689 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750832AbeBJCxz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Feb 2018 21:53:55 -0500
In-Reply-To: <1518228763-12937-1-git-send-email-jpittman@redhat.com>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Pittman <jpittman@redhat.com>, martin.petersen@oracle.com
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

As per the subject line, I wouldn't mind putting these changes in with
the pigs :-)

On 2018-02-09 09:12 PM, John Pittman wrote:
> Pointer styling issues exposed by checkpatch.pl in scsi_debug.c:
> 
>     ERROR: "foo * bar" should be "foo *bar"
> 
> Fixed 37 total errors reported.
> 
> Signed-off-by: John Pittman <jpittman@redhat.com>

Ack-ed by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 72 +++++++++++++++++++++++------------------------
>   1 file changed, 36 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index a5986da..a1f867f 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -1155,8 +1155,8 @@ static int inquiry_vpd_84(unsigned char *arr)
>   static int inquiry_vpd_85(unsigned char *arr)
>   {
>   	int num = 0;
> -	const char * na1 = "https://www.kernel.org/config";
> -	const char * na2 = "http://www.kernel.org/log";
> +	const char *na1 = "https://www.kernel.org/config";
> +	const char *na2 = "http://www.kernel.org/log";
>   	int plen, olen;
>   
>   	arr[num++] = 0x1;	/* lu, storage config */
> @@ -1372,7 +1372,7 @@ static int inquiry_vpd_b2(unsigned char *arr)
>   static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   {
>   	unsigned char pq_pdt;
> -	unsigned char * arr;
> +	unsigned char *arr;
>   	unsigned char *cmd = scp->cmnd;
>   	int alloc_len, n, ret;
>   	bool have_wlun, is_disk;
> @@ -1523,10 +1523,10 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   static unsigned char iec_m_pg[] = {0x1c, 0xa, 0x08, 0, 0, 0, 0, 0,
>   				   0, 0, 0x0, 0x0};
>   
> -static int resp_requests(struct scsi_cmnd * scp,
> -			 struct sdebug_dev_info * devip)
> +static int resp_requests(struct scsi_cmnd *scp,
> +			 struct sdebug_dev_info *devip)
>   {
> -	unsigned char * sbuff;
> +	unsigned char *sbuff;
>   	unsigned char *cmd = scp->cmnd;
>   	unsigned char arr[SCSI_SENSE_BUFFERSIZE];
>   	bool dsense;
> @@ -1584,8 +1584,8 @@ static int resp_requests(struct scsi_cmnd * scp,
>   	return fill_from_dev_buffer(scp, arr, len);
>   }
>   
> -static int resp_start_stop(struct scsi_cmnd * scp,
> -			   struct sdebug_dev_info * devip)
> +static int resp_start_stop(struct scsi_cmnd *scp,
> +			   struct sdebug_dev_info *devip)
>   {
>   	unsigned char *cmd = scp->cmnd;
>   	int power_cond, stop;
> @@ -1612,8 +1612,8 @@ static sector_t get_sdebug_capacity(void)
>   }
>   
>   #define SDEBUG_READCAP_ARR_SZ 8
> -static int resp_readcap(struct scsi_cmnd * scp,
> -			struct sdebug_dev_info * devip)
> +static int resp_readcap(struct scsi_cmnd *scp,
> +			struct sdebug_dev_info *devip)
>   {
>   	unsigned char arr[SDEBUG_READCAP_ARR_SZ];
>   	unsigned int capac;
> @@ -1631,8 +1631,8 @@ static int resp_readcap(struct scsi_cmnd * scp,
>   }
>   
>   #define SDEBUG_READCAP16_ARR_SZ 32
> -static int resp_readcap16(struct scsi_cmnd * scp,
> -			  struct sdebug_dev_info * devip)
> +static int resp_readcap16(struct scsi_cmnd *scp,
> +			  struct sdebug_dev_info *devip)
>   {
>   	unsigned char *cmd = scp->cmnd;
>   	unsigned char arr[SDEBUG_READCAP16_ARR_SZ];
> @@ -1670,11 +1670,11 @@ static int resp_readcap16(struct scsi_cmnd * scp,
>   
>   #define SDEBUG_MAX_TGTPGS_ARR_SZ 1412
>   
> -static int resp_report_tgtpgs(struct scsi_cmnd * scp,
> -			      struct sdebug_dev_info * devip)
> +static int resp_report_tgtpgs(struct scsi_cmnd *scp,
> +			      struct sdebug_dev_info *devip)
>   {
>   	unsigned char *cmd = scp->cmnd;
> -	unsigned char * arr;
> +	unsigned char *arr;
>   	int host_no = devip->sdbg_host->shost->host_no;
>   	int n, ret, alen, rlen;
>   	int port_group_a, port_group_b, port_a, port_b;
> @@ -1926,7 +1926,7 @@ static int resp_rsup_tmfs(struct scsi_cmnd *scp,
>   
>   /* <<Following mode page info copied from ST318451LW>> */
>   
> -static int resp_err_recov_pg(unsigned char * p, int pcontrol, int target)
> +static int resp_err_recov_pg(unsigned char *p, int pcontrol, int target)
>   {	/* Read-Write Error Recovery page for mode_sense */
>   	unsigned char err_recov_pg[] = {0x1, 0xa, 0xc0, 11, 240, 0, 0, 0,
>   					5, 0, 0xff, 0xff};
> @@ -1937,7 +1937,7 @@ static int resp_err_recov_pg(unsigned char * p, int pcontrol, int target)
>   	return sizeof(err_recov_pg);
>   }
>   
> -static int resp_disconnect_pg(unsigned char * p, int pcontrol, int target)
> +static int resp_disconnect_pg(unsigned char *p, int pcontrol, int target)
>   { 	/* Disconnect-Reconnect page for mode_sense */
>   	unsigned char disconnect_pg[] = {0x2, 0xe, 128, 128, 0, 10, 0, 0,
>   					 0, 0, 0, 0, 0, 0, 0, 0};
> @@ -1948,7 +1948,7 @@ static int resp_disconnect_pg(unsigned char * p, int pcontrol, int target)
>   	return sizeof(disconnect_pg);
>   }
>   
> -static int resp_format_pg(unsigned char * p, int pcontrol, int target)
> +static int resp_format_pg(unsigned char *p, int pcontrol, int target)
>   {       /* Format device page for mode_sense */
>   	unsigned char format_pg[] = {0x3, 0x16, 0, 0, 0, 0, 0, 0,
>   				     0, 0, 0, 0, 0, 0, 0, 0,
> @@ -1968,7 +1968,7 @@ static unsigned char caching_pg[] = {0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
>   				     0xff, 0xff, 0xff, 0xff, 0x80, 0x14, 0, 0,
>   				     0, 0, 0, 0};
>   
> -static int resp_caching_pg(unsigned char * p, int pcontrol, int target)
> +static int resp_caching_pg(unsigned char *p, int pcontrol, int target)
>   { 	/* Caching page for mode_sense */
>   	unsigned char ch_caching_pg[] = {/* 0x8, 18, */ 0x4, 0, 0, 0, 0, 0,
>   		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
> @@ -1988,7 +1988,7 @@ static int resp_caching_pg(unsigned char * p, int pcontrol, int target)
>   static unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
>   				    0, 0, 0x2, 0x4b};
>   
> -static int resp_ctrl_m_pg(unsigned char * p, int pcontrol, int target)
> +static int resp_ctrl_m_pg(unsigned char *p, int pcontrol, int target)
>   { 	/* Control mode page for mode_sense */
>   	unsigned char ch_ctrl_m_pg[] = {/* 0xa, 10, */ 0x6, 0, 0, 0, 0, 0,
>   					0, 0, 0, 0};
> @@ -2012,7 +2012,7 @@ static int resp_ctrl_m_pg(unsigned char * p, int pcontrol, int target)
>   }
>   
>   
> -static int resp_iec_m_pg(unsigned char * p, int pcontrol, int target)
> +static int resp_iec_m_pg(unsigned char *p, int pcontrol, int target)
>   {	/* Informational Exceptions control mode page for mode_sense */
>   	unsigned char ch_iec_m_pg[] = {/* 0x1c, 0xa, */ 0x4, 0xf, 0, 0, 0, 0,
>   				       0, 0, 0x0, 0x0};
> @@ -2027,7 +2027,7 @@ static int resp_iec_m_pg(unsigned char * p, int pcontrol, int target)
>   	return sizeof(iec_m_pg);
>   }
>   
> -static int resp_sas_sf_m_pg(unsigned char * p, int pcontrol, int target)
> +static int resp_sas_sf_m_pg(unsigned char *p, int pcontrol, int target)
>   {	/* SAS SSP mode page - short format for mode_sense */
>   	unsigned char sas_sf_m_pg[] = {0x19, 0x6,
>   		0x6, 0x0, 0x7, 0xd0, 0x0, 0x0};
> @@ -2039,7 +2039,7 @@ static int resp_sas_sf_m_pg(unsigned char * p, int pcontrol, int target)
>   }
>   
>   
> -static int resp_sas_pcd_m_spg(unsigned char * p, int pcontrol, int target,
> +static int resp_sas_pcd_m_spg(unsigned char *p, int pcontrol, int target,
>   			      int target_dev_id)
>   {	/* SAS phy control and discover mode page for mode_sense */
>   	unsigned char sas_pcd_m_pg[] = {0x59, 0x1, 0, 0x64, 0, 0x6, 0, 2,
> @@ -2072,7 +2072,7 @@ static int resp_sas_pcd_m_spg(unsigned char * p, int pcontrol, int target,
>   	return sizeof(sas_pcd_m_pg);
>   }
>   
> -static int resp_sas_sha_m_spg(unsigned char * p, int pcontrol)
> +static int resp_sas_sha_m_spg(unsigned char *p, int pcontrol)
>   {	/* SAS SSP shared protocol specific port mode subpage */
>   	unsigned char sas_sha_m_pg[] = {0x59, 0x2, 0, 0xc, 0, 0x6, 0x10, 0,
>   		    0, 0, 0, 0, 0, 0, 0, 0,
> @@ -2093,7 +2093,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
>   	unsigned char dev_spec;
>   	int alloc_len, offset, len, target_dev_id;
>   	int target = scp->device->id;
> -	unsigned char * ap;
> +	unsigned char *ap;
>   	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
>   	unsigned char *cmd = scp->cmnd;
>   	bool dbd, llbaa, msense_6, is_disk, bad_pcode;
> @@ -2324,7 +2324,7 @@ static int resp_mode_select(struct scsi_cmnd *scp,
>   	return 0;
>   }
>   
> -static int resp_temp_l_pg(unsigned char * arr)
> +static int resp_temp_l_pg(unsigned char *arr)
>   {
>   	unsigned char temp_l_pg[] = {0x0, 0x0, 0x3, 0x2, 0x0, 38,
>   				     0x0, 0x1, 0x3, 0x2, 0x0, 65,
> @@ -2334,7 +2334,7 @@ static int resp_temp_l_pg(unsigned char * arr)
>   	return sizeof(temp_l_pg);
>   }
>   
> -static int resp_ie_l_pg(unsigned char * arr)
> +static int resp_ie_l_pg(unsigned char *arr)
>   {
>   	unsigned char ie_l_pg[] = {0x0, 0x0, 0x3, 0x3, 0x0, 0x0, 38,
>   		};
> @@ -4066,7 +4066,7 @@ static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
>   	return SUCCESS;
>   }
>   
> -static int scsi_debug_device_reset(struct scsi_cmnd * SCpnt)
> +static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
>   {
>   	++num_dev_resets;
>   	if (SCpnt && SCpnt->device) {
> @@ -4118,7 +4118,7 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
>   	return SUCCESS;
>   }
>   
> -static int scsi_debug_bus_reset(struct scsi_cmnd * SCpnt)
> +static int scsi_debug_bus_reset(struct scsi_cmnd *SCpnt)
>   {
>   	struct sdebug_host_info *sdbg_host;
>   	struct sdebug_dev_info *devip;
> @@ -4151,9 +4151,9 @@ static int scsi_debug_bus_reset(struct scsi_cmnd * SCpnt)
>   	return SUCCESS;
>   }
>   
> -static int scsi_debug_host_reset(struct scsi_cmnd * SCpnt)
> +static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
>   {
> -	struct sdebug_host_info * sdbg_host;
> +	struct sdebug_host_info *sdbg_host;
>   	struct sdebug_dev_info *devip;
>   	int k = 0;
>   
> @@ -4179,7 +4179,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd * SCpnt)
>   static void __init sdebug_build_parts(unsigned char *ramp,
>   				      unsigned long store_size)
>   {
> -	struct partition * pp;
> +	struct partition *pp;
>   	int starts[SDEBUG_MAX_PARTS + 2];
>   	int sectors_per_part, num_sectors, k;
>   	int heads_by_sects, start_sec, end_sec;
> @@ -4526,7 +4526,7 @@ MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xff
>   #define SDEBUG_INFO_LEN 256
>   static char sdebug_info[SDEBUG_INFO_LEN];
>   
> -static const char * scsi_debug_info(struct Scsi_Host * shp)
> +static const char *scsi_debug_info(struct Scsi_Host *shp)
>   {
>   	int k;
>   
> @@ -5450,7 +5450,7 @@ static void __exit scsi_debug_exit(void)
>   device_initcall(scsi_debug_init);
>   module_exit(scsi_debug_exit);
>   
> -static void sdebug_release_adapter(struct device * dev)
> +static void sdebug_release_adapter(struct device *dev)
>   {
>   	struct sdebug_host_info *sdbg_host;
>   
> @@ -5757,7 +5757,7 @@ static struct scsi_host_template sdebug_driver_template = {
>   	.track_queue_depth =	1,
>   };
>   
> -static int sdebug_driver_probe(struct device * dev)
> +static int sdebug_driver_probe(struct device *dev)
>   {
>   	int error = 0;
>   	struct sdebug_host_info *sdbg_host;
> @@ -5855,7 +5855,7 @@ static int sdebug_driver_probe(struct device * dev)
>   	return error;
>   }
>   
> -static int sdebug_driver_remove(struct device * dev)
> +static int sdebug_driver_remove(struct device *dev)
>   {
>   	struct sdebug_host_info *sdbg_host;
>   	struct sdebug_dev_info *sdbg_devinfo, *tmp;
> 
