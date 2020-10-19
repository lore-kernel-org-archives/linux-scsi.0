Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_50_75,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1CCC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 15:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B262F22363
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 15:29:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NzLOr/bt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgJSP3B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 11:29:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48052 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729968AbgJSP3B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 11:29:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JFE5oZ024919;
        Mon, 19 Oct 2020 15:28:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=f1ldLHzUwznGdA2JZffRCGRXa+iaZehUGipxrs0B760=;
 b=NzLOr/btTRqJklxq61yWQY09c7z/x/0NXP16bQdc6G07XRzFmHslzpatByizuZGWihXJ
 FQNPo5Y8MAWRw3xYicidzqzgkfqqWYIgKQ+A89OcE3LU2faMhZFFcEHWYB10ZtvNtwkG
 s877396wQkf7ne+UhW/hUANkEGRO2EPAoo9gBZhSrPziCcANNQ9FBC475ynZ3iskksgG
 L5kQxFXerwwAPqvryETLOaJiREkB0IWCmwEy9DsMNh09M541+ry/Im5VNmGLDYjq+V7d
 LzEdCtPVg4nIcNymL402x93Cz6ypsWM6bcZn/H0InkV/wSnjn7QvxXunDzCRMScMOwzU PQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 347s8mp4jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 15:28:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JFFp7k012837;
        Mon, 19 Oct 2020 15:26:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 348acpkxux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 15:26:58 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09JFQv0I001840;
        Mon, 19 Oct 2020 15:26:57 GMT
Received: from [192.168.1.25] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 08:26:57 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 2/4] include:scsi:fc: FDMI enhancement
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201009093631.4182-3-jhasan@marvell.com>
Date:   Mon, 19 Oct 2020 10:26:55 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: 7bit
Message-Id: <7207E967-5713-4F67-8F06-7EA25C206F84@oracle.com>
References: <20201009093631.4182-1-jhasan@marvell.com>
 <20201009093631.4182-3-jhasan@marvell.com>
To:     Javed Hasan <jhasan@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 9, 2020, at 4:36 AM, Javed Hasan <jhasan@marvell.com> wrote:
> 
> All the attributes added for RHBA and RPA registration.
> Fall back mechanism is added in between RBHA V2 and
> RHBA V1 attributes. In case RHBA get failed
> for RBHA V2 attributes, then we fall back to  RHBA V1
> attributes registration.
> 
> Signed-off-by: Javed Hasan <jhasan@marvell.com>
> ---
> include/scsi/fc/fc_ms.h | 59 ++++++++++++++++++++++++++++++++++-------
> 1 file changed, 50 insertions(+), 9 deletions(-)
> 
> diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
> index 9e273fed0a85..abbd6bacc888 100644
> --- a/include/scsi/fc/fc_ms.h
> +++ b/include/scsi/fc/fc_ms.h
> @@ -24,6 +24,12 @@
>  */
> #define	FC_FDMI_SUBTYPE	    0x10 /* fs_ct_hdr.ct_fs_subtype */
> 
> +/*
> + * Management server FDMI specifications.
> + */
> +#define	FDMI_V1	    1 /* FDMI version 1 specifications */
> +#define	FDMI_V2	    2 /* FDMI version 2 specifications */
> +
> /*
>  * Management server FDMI Requests.
>  */
> @@ -57,22 +63,36 @@ enum fc_fdmi_hba_attr_type {
> 	FC_FDMI_HBA_ATTR_FIRMWAREVERSION = 0x0009,
> 	FC_FDMI_HBA_ATTR_OSNAMEVERSION = 0x000A,
> 	FC_FDMI_HBA_ATTR_MAXCTPAYLOAD = 0x000B,
> +	FC_FDMI_HBA_ATTR_NODESYMBLNAME = 0x000C,
> +	FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO = 0x000D,
> +	FC_FDMI_HBA_ATTR_NUMBEROFPORTS = 0x000E,
> +	FC_FDMI_HBA_ATTR_FABRICNAME = 0x000F,
> +	FC_FDMI_HBA_ATTR_BIOSVERSION = 0x0010,
> +	FC_FDMI_HBA_ATTR_BIOSSTATE = 0x0011,
> +	FC_FDMI_HBA_ATTR_VENDORIDENTIFIER = 0x00E0,
> };
> 
> /*
>  * HBA Attribute Length
>  */
> #define FC_FDMI_HBA_ATTR_NODENAME_LEN		8
> -#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	80
> -#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	80
> -#define FC_FDMI_HBA_ATTR_MODEL_LEN		256
> -#define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		256
> -#define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	256
> -#define FC_FDMI_HBA_ATTR_DRIVERVERSION_LEN	256
> -#define FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN	256
> -#define FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN	256
> -#define FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN	256
> +#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	64
> +#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	64

These below value of 100 seems odd. How did you decided on this value? 

> +#define FC_FDMI_HBA_ATTR_MODEL_LEN		100
> +#define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		100
> +#define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	100
> +#define FC_FDMI_HBA_ATTR_DRIVERVERSION_LEN	100
> +#define FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN	100
> +#define FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN	100
> +#define FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN	100
> #define FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN	4
> +#define FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN	100
> +#define FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO_LEN	4
> +#define FC_FDMI_HBA_ATTR_NUMBEROFPORTS_LEN	4
> +#define FC_FDMI_HBA_ATTR_FABRICNAME_LEN	8
> +#define FC_FDMI_HBA_ATTR_BIOSVERSION_LEN	100
> +#define FC_FDMI_HBA_ATTR_BIOSSTATE_LEN    4
> +#define FC_FDMI_HBA_ATTR_VENDORIDENTIFIER_LEN 8
> 
> /*
>  * Port Attribute Type
> @@ -84,6 +104,16 @@ enum fc_fdmi_port_attr_type {
> 	FC_FDMI_PORT_ATTR_MAXFRAMESIZE = 0x0004,
> 	FC_FDMI_PORT_ATTR_OSDEVICENAME = 0x0005,
> 	FC_FDMI_PORT_ATTR_HOSTNAME = 0x0006,
> +	FC_FDMI_PORT_ATTR_NODENAME = 0x0007,
> +	FC_FDMI_PORT_ATTR_PORTNAME = 0x0008,
> +	FC_FDMI_PORT_ATTR_SYMBOLICNAME = 0x0009,
> +	FC_FDMI_PORT_ATTR_PORTTYPE = 0x000A,
> +	FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC = 0x000B,
> +	FC_FDMI_PORT_ATTR_FABRICNAME = 0x000C,
> +	FC_FDMI_PORT_ATTR_CURRENTFC4TYPE = 0x000D,
> +	FC_FDMI_PORT_ATTR_PORTSTATE = 0x101,
> +	FC_FDMI_PORT_ATTR_DISCOVEREDPORTS = 0x102,
> +	FC_FDMI_PORT_ATTR_PORTID = 0x103,
> };
> 
> /*
> @@ -95,6 +125,17 @@ enum fc_fdmi_port_attr_type {
> #define FC_FDMI_PORT_ATTR_MAXFRAMESIZE_LEN	4
> #define FC_FDMI_PORT_ATTR_OSDEVICENAME_LEN	256
> #define FC_FDMI_PORT_ATTR_HOSTNAME_LEN		256
> +#define FC_FDMI_PORT_ATTR_NODENAME_LEN		8
> +#define FC_FDMI_PORT_ATTR_PORTNAME_LEN		8
> +#define FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN	256
> +#define FC_FDMI_PORT_ATTR_PORTTYPE_LEN		4
> +#define FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC_LEN	4
> +#define FC_FDMI_PORT_ATTR_FABRICNAME_LEN	8
> +#define FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN	32
> +#define FC_FDMI_PORT_ATTR_PORTSTATE_LEN		4
> +#define FC_FDMI_PORT_ATTR_DISCOVEREDPORTS_LEN	4
> +#define FC_FDMI_PORT_ATTR_PORTID_LEN		4
> +
> 
> /*
>  * HBA Attribute ID
> -- 
> 2.18.2
> 

--
Himanshu Madhani	 Oracle Linux Engineering

