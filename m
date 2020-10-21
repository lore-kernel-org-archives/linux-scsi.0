Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA20BC388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 14:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CD1322283
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 14:46:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fWWws1t8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443116AbgJUOqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 10:46:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55614 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395254AbgJUOqj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 10:46:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LEjEWZ014798;
        Wed, 21 Oct 2020 14:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=8HMg4DcZusQLkK3MHXCkrxj2XZZ88oGdxlqqNIcHmto=;
 b=fWWws1t8UpTs56+iPlTOk6GkyTfHD7KmOgayLX1VFPo26+N0w9p/sQ9FmW/KEWyI2tQ+
 XY4ddXO5z2alHJQ+wKXjwn4oE7f9Pzx9EhYqw6SCoDYGavJDfrC1IFBqTjWn4rimDvqC
 3QjD1jmsMjlUh8Do8LtjfdCnKSKRrInMnP+56LF8p7mUAP9zJkY86sKRkvyKbB/IJz6c
 ODvvpeOAdzobsGQoGLaXJFMaU2MNY5wUfeu3yT56nYAhQhfcK8nwIBwSITgrCbXAJPlv
 UkK60uMxpfz3K8t8SFK99e8bhvizUabKD+8sy1Y0PB87knwBKiqxi8IMOfNYlfbZmJ64 TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 347p4b11uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Oct 2020 14:46:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LEixpA060283;
        Wed, 21 Oct 2020 14:46:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 348ahxnwyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 14:46:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09LEkaId025403;
        Wed, 21 Oct 2020 14:46:36 GMT
Received: from [192.168.1.6] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 07:46:35 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 1/5] scsi: fc: Update formal FPIN descriptor
 definitions
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201021092715.22669-2-njavali@marvell.com>
Date:   Wed, 21 Oct 2020 09:46:35 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: 7bit
Message-Id: <924243C0-FEC5-4D75-B07A-4D8501A07499@oracle.com>
References: <20201021092715.22669-1-njavali@marvell.com>
 <20201021092715.22669-2-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2020, at 4:27 AM, Nilesh Javali <njavali@marvell.com> wrote:
> 
> From: Shyam Sundar <ssundar@marvell.com>
> 
> Add Fabric Performance Impact Notification (FPIN) descriptor definition
> for the following FPINs:
> Delivery Notification Descriptor
> Peer Congestion Notification Descriptor
> Congestion Notification Descriptor
> 
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Reviewed-by: James Smart <james.smart@broadcom.com>
> ---
> include/uapi/scsi/fc/fc_els.h | 114 +++++++++++++++++++++++++++++++++-
> 1 file changed, 113 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
> index 8c704e510e39..91d4be987220 100644
> --- a/include/uapi/scsi/fc/fc_els.h
> +++ b/include/uapi/scsi/fc/fc_els.h
> @@ -916,7 +916,9 @@ enum fc_els_clid_ic {
> 	ELS_CLID_IC_LIP =	8,	/* receiving LIP */
> };
> 
> -
> +/*
> + * Link Integrity event types
> + */
> enum fc_fpin_li_event_types {
> 	FPIN_LI_UNKNOWN =		0x0,
> 	FPIN_LI_LINK_FAILURE =		0x1,
> @@ -943,6 +945,54 @@ enum fc_fpin_li_event_types {
> 	{ FPIN_LI_DEVICE_SPEC,		"Device Specific" },		\
> }
> 
> +/*
> + * Delivery event types
> + */
> +enum fc_fpin_deli_event_types {
> +	FPIN_DELI_UNKNOWN =		0x0,
> +	FPIN_DELI_TIMEOUT =		0x1,
> +	FPIN_DELI_UNABLE_TO_ROUTE =	0x2,
> +	FPIN_DELI_DEVICE_SPEC =		0xF,
> +};
> +
> +/*
> + * Initializer useful for decoding table.
> + * Please keep this in sync with the above definitions.
> + */
> +#define FC_FPIN_DELI_EVT_TYPES_INIT {					\
> +	{ FPIN_DELI_UNKNOWN,		"Unknown" },			\
> +	{ FPIN_DELI_TIMEOUT,		"Timeout" },			\
> +	{ FPIN_DELI_UNABLE_TO_ROUTE,	"Unable to Route" },		\
> +	{ FPIN_DELI_DEVICE_SPEC,	"Device Specific" },		\
> +}
> +
> +/*
> + * Congestion event types
> + */
> +enum fc_fpin_congn_event_types {
> +	FPIN_CONGN_CLEAR =		0x0,
> +	FPIN_CONGN_LOST_CREDIT =	0x1,
> +	FPIN_CONGN_CREDIT_STALL =	0x2,
> +	FPIN_CONGN_OVERSUBSCRIPTION =	0x3,
> +	FPIN_CONGN_DEVICE_SPEC =	0xF,
> +};
> +
> +/*
> + * Initializer useful for decoding table.
> + * Please keep this in sync with the above definitions.
> + */
> +#define FC_FPIN_CONGN_EVT_TYPES_INIT {					\
> +	{ FPIN_CONGN_CLEAR,		"Clear" },			\
> +	{ FPIN_CONGN_LOST_CREDIT,	"Lost Credit" },		\
> +	{ FPIN_CONGN_CREDIT_STALL,	"Credit Stall" },		\
> +	{ FPIN_CONGN_OVERSUBSCRIPTION,	"Oversubscription" },		\
> +	{ FPIN_CONGN_DEVICE_SPEC,	"Device Specific" },		\
> +}
> +
> +enum fc_fpin_congn_severity_types {
> +	FPIN_CONGN_SEVERITY_WARNING =	0xF1,
> +	FPIN_CONGN_SEVERITY_ERROR =	0xF7,
> +};
> 
> /*
>  * Link Integrity Notification Descriptor
> @@ -974,6 +1024,68 @@ struct fc_fn_li_desc {
> 					 */
> };
> 
> +/*
> + * Delivery Notification Descriptor
> + */
> +struct fc_fn_deli_desc {
> +	__be32		desc_tag;	/* Descriptor Tag (0x00020002) */
> +	__be32		desc_len;	/* Length of Descriptor (in bytes).
> +					 * Size of descriptor excluding
> +					 * desc_tag and desc_len fields.
> +					 */
> +	__be64		detecting_wwpn;	/* Port Name that detected event */
> +	__be64		attached_wwpn;	/* Port Name of device attached to
> +					 * detecting Port Name
> +					 */
> +	__be32		deli_reason_code;/* see enum fc_fpin_deli_event_types */
> +};
> +
> +/*
> + * Peer Congestion Notification Descriptor
> + */
> +struct fc_fn_peer_congn_desc {
> +	__be32		desc_tag;	/* Descriptor Tag (0x00020003) */
> +	__be32		desc_len;	/* Length of Descriptor (in bytes).
> +					 * Size of descriptor excluding
> +					 * desc_tag and desc_len fields.
> +					 */
> +	__be64		detecting_wwpn;	/* Port Name that detected event */
> +	__be64		attached_wwpn;	/* Port Name of device attached to
> +					 * detecting Port Name
> +					 */
> +	__be16		event_type;	/* see enum fc_fpin_congn_event_types */
> +	__be16		event_modifier;	/* Implementation specific value
> +					 * describing the event type
> +					 */
> +	__be32		event_period;	/* duration (ms) of the detected
> +					 * congestion event
> +					 */
> +	__be32		pname_count;	/* number of portname_list elements */
> +	__be64		pname_list[0];	/* list of N_Port_Names accessible
> +					 * through the attached port
> +					 */
> +};
> +
> +/*
> + * Congestion Notification Descriptor
> + */
> +struct fc_fn_congn_desc {
> +	__be32		desc_tag;	/* Descriptor Tag (0x00020004) */
> +	__be32		desc_len;	/* Length of Descriptor (in bytes).
> +					 * Size of descriptor excluding
> +					 * desc_tag and desc_len fields.
> +					 */
> +	__be16		event_type;	/* see enum fc_fpin_congn_event_types */
> +	__be16		event_modifier;	/* Implementation specific value
> +					 * describing the event type
> +					 */
> +	__be32		event_period;	/* duration (ms) of the detected
> +					 * congestion event
> +					 */
> +	__u8		severity;	/* command */
> +	__u8		resv[3];	/* reserved - must be zero */
> +};
> +
> /*
>  * ELS_FPIN - Fabric Performance Impact Notification
>  */
> -- 
> 2.19.0.rc0
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

