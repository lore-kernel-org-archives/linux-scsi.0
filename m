Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7CAC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 18:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4361207DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 18:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGISOS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 14:14:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726684AbgGISOS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 14:14:18 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 069I31LZ133946;
        Thu, 9 Jul 2020 14:14:11 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 325ktt3j8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 14:14:11 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 069I9Zv1010074;
        Thu, 9 Jul 2020 18:14:10 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 325k1nt6f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Jul 2020 18:14:10 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 069IE6AH29032934
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Jul 2020 18:14:06 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6121D78066;
        Thu,  9 Jul 2020 18:14:09 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 404DE78063;
        Thu,  9 Jul 2020 18:14:08 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.80.239.156])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  9 Jul 2020 18:14:07 +0000 (GMT)
Message-ID: <1594318443.10411.14.camel@linux.ibm.com>
Subject: Re: [PATCH 24/24] scsi: aic7xxx: aic79xx_osm: Remove set but unused
 variabes 'saved_scsiid' and 'saved_modes'
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Lee Jones <lee.jones@linaro.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Date:   Thu, 09 Jul 2020 11:14:03 -0700
In-Reply-To: <20200709174556.7651-25-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
         <20200709174556.7651-25-lee.jones@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_09:2020-07-09,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=929 phishscore=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-07-09 at 18:45 +0100, Lee Jones wrote:
> Haven't been used since 2006.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/scsi/aic7xxx/aic79xx_osm.c: In function
> ‘ahd_linux_queue_abort_cmd’:
>  drivers/scsi/aic7xxx/aic79xx_osm.c:2155:17: warning: variable
> ‘saved_modes’ set but not used [-Wunused-but-set-variable]
>  drivers/scsi/aic7xxx/aic79xx_osm.c:2148:9: warning: variable
> ‘saved_scsiid’ set but not used [-Wunused-but-set-variable]
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/scsi/aic7xxx/aic79xx_osm.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c
> b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index 3782a20d58885..b0c6701f64a83 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -2141,14 +2141,12 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> *cmd)
>  	u_int  saved_scbptr;
>  	u_int  active_scbptr;
>  	u_int  last_phase;
> -	u_int  saved_scsiid;
>  	u_int  cdb_byte;
>  	int    retval;
>  	int    was_paused;
>  	int    paused;
>  	int    wait;
>  	int    disconnected;
> -	ahd_mode_state saved_modes;
>  	unsigned long flags;
>  
>  	pending_scb = NULL;
> @@ -2239,7 +2237,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> *cmd)
>  		goto done;
>  	}
>  
> -	saved_modes = ahd_save_modes(ahd);
> +	ahd_save_modes(ahd);

Well, this is clearly wrong, since ahd_save_modes has no side effects.

However, I think it also means there's a bug in this code:

>  	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);

You can't do this without later restoring the mode, so someone needs to
figure out where the missing ahd_restore_modes() should go.

>  	last_phase = ahd_inb(ahd, LASTPHASE);
>  	saved_scbptr = ahd_get_scbptr(ahd);
> @@ -2257,7 +2255,7 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> *cmd)
>  	 * passed in command.  That command is currently active on
> the
>  	 * bus or is in the disconnected state.
>  	 */
> -	saved_scsiid = ahd_inb(ahd, SAVED_SCSIID);
> +	ahd_inb(ahd, SAVED_SCSIID);

I think this can just go.

James

