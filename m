Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EA4C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 15:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40CD52222E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 15:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgGNPoD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 11:44:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30146 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725280AbgGNPoD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 11:44:03 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06EFVB2X154713;
        Tue, 14 Jul 2020 11:43:55 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 328s1hrnhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 11:43:55 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06EFV8Gb017741;
        Tue, 14 Jul 2020 15:43:54 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04wdc.us.ibm.com with ESMTP id 327528sghs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jul 2020 15:43:54 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06EFhq3963439300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 15:43:52 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8D2478063;
        Tue, 14 Jul 2020 15:43:53 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0867B7805E;
        Tue, 14 Jul 2020 15:43:51 +0000 (GMT)
Received: from [153.66.254.194] (unknown [9.85.141.100])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jul 2020 15:43:51 +0000 (GMT)
Message-ID: <1594741430.4545.15.camel@linux.ibm.com>
Subject: Re: [PATCH v2 24/24] scsi: aic7xxx: aic79xx_osm: Remove set but
 unused variabes 'saved_scsiid' and 'saved_modes'
From:   James Bottomley <jejb@linux.ibm.com>
Reply-To: jejb@linux.ibm.com
To:     Hannes Reinecke <hare@suse.de>, Lee Jones <lee.jones@linaro.org>,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
Date:   Tue, 14 Jul 2020 08:43:50 -0700
In-Reply-To: <559e47de-fa26-9ae5-a3c5-4adeae606309@suse.de>
References: <20200713080001.128044-1-lee.jones@linaro.org>
         <20200713080001.128044-25-lee.jones@linaro.org>
         <559e47de-fa26-9ae5-a3c5-4adeae606309@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-14_05:2020-07-14,2020-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 mlxscore=0 clxscore=1015 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140114
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-07-14 at 09:46 +0200, Hannes Reinecke wrote:
> On 7/13/20 10:00 AM, Lee Jones wrote:
> > Haven't been used since 2006.
> > 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/scsi/aic7xxx/aic79xx_osm.c: In function
> > ‘ahd_linux_queue_abort_cmd’:
> >  drivers/scsi/aic7xxx/aic79xx_osm.c:2155:17: warning: variable
> > ‘saved_modes’ set but not used [-Wunused-but-set-variable]
> >  drivers/scsi/aic7xxx/aic79xx_osm.c:2148:9: warning: variable
> > ‘saved_scsiid’ set but not used [-Wunused-but-set-variable]
> > 
> > Cc: Hannes Reinecke <hare@suse.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/scsi/aic7xxx/aic79xx_osm.c | 4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c
> > b/drivers/scsi/aic7xxx/aic79xx_osm.c
> > index 3782a20d58885..140c4e74ddd7e 100644
> > --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> > +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> > @@ -2141,14 +2141,12 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> > *cmd)
> >  	u_int  saved_scbptr;
> >  	u_int  active_scbptr;
> >  	u_int  last_phase;
> > -	u_int  saved_scsiid;
> >  	u_int  cdb_byte;
> >  	int    retval;
> >  	int    was_paused;
> >  	int    paused;
> >  	int    wait;
> >  	int    disconnected;
> > -	ahd_mode_state saved_modes;
> >  	unsigned long flags;
> >  
> >  	pending_scb = NULL;
> > @@ -2239,7 +2237,6 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> > *cmd)
> >  		goto done;
> >  	}
> >  
> > -	saved_modes = ahd_save_modes(ahd);
> >  	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
> >  	last_phase = ahd_inb(ahd, LASTPHASE);
> >  	saved_scbptr = ahd_get_scbptr(ahd);
> > @@ -2257,7 +2254,6 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd
> > *cmd)
> >  	 * passed in command.  That command is currently active on
> > the
> >  	 * bus or is in the disconnected state.
> >  	 */
> > -	saved_scsiid = ahd_inb(ahd, SAVED_SCSIID);
> >  	if (last_phase != P_BUSFREE
> >  	    && SCB_GET_TAG(pending_scb) == active_scbptr) {
> >  
> > 
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Hey, you don't get to do that ... I asked you to figure out why we're
missing an ahd_restore_modes().  Removing the ahd_save_modes() is
cosmetic: it gets rid of a warning but doesn't fix the problem.  I'd
rather keep the warning until the problem is fixed and the problem is
we need a mode save/restore around the ahd_set_modes() which is only
partially implemented in this function.

James

