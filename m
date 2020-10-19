Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 403CBC433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 16:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDA3F2224D
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 16:04:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nSQf+mVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgJSQEv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:04:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52848 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730538AbgJSQEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 12:04:51 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JG0QPi117381;
        Mon, 19 Oct 2020 16:04:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Gk8g2qIloRuSn3MG8EQ+uIp8iGL0vwLJhTpB6n+40MI=;
 b=nSQf+mVS+Ga2oR1JDVcdZBAsTcRp/z+pjeT5nSL2q0eEaYc57Z7MIzgINv2hqQFfM7vj
 8BMyuO2nTCjI/CjgDyY6qrpT9ncqnvT4CT02mx0k5q4LDJkiNo7oOvCu4D5EIVBr+u2r
 kzLiAoE0Em2N+uduqaejERcYH0Kb25WFpPLzYaWknBoENzL+dPMjmhfv3O8OxZdmXW06
 qyZWixy6xYntTKJByp8k+ImED/WvBXeX3PLHxG26kBDLCB26TKQ6CpIgsQnUxehqKTYA
 uVobOIMzJDF6IcyBXrMdQtWcNOvnSglfMXLVgfyJTKrP/biGxrA4Vv+wGbgXCZvrM6o4 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 347s8mpan7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 16:04:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JFxpQo147850;
        Mon, 19 Oct 2020 16:04:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 348acpn7xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 16:04:48 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09JG4l7c006459;
        Mon, 19 Oct 2020 16:04:47 GMT
Received: from [192.168.1.25] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 09:04:47 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 4/4] scsi:qedf: Added attributes for RHBA and RPA
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201009093631.4182-5-jhasan@marvell.com>
Date:   Mon, 19 Oct 2020 11:04:46 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: 7bit
Message-Id: <40A84614-A410-487C-8726-7AF2B7D01FAB@oracle.com>
References: <20201009093631.4182-1-jhasan@marvell.com>
 <20201009093631.4182-5-jhasan@marvell.com>
To:     Javed Hasan <jhasan@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190110
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 9, 2020, at 4:36 AM, Javed Hasan <jhasan@marvell.com> wrote:
> 
> Add attributes for RHBA and RPA.
> 
> Signed-off-by: Javed Hasan <jhasan@marvell.com>
> ---
> drivers/scsi/qedf/qedf_main.c | 11 +++++++++++
> 1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index 46d185cb9ea8..e4d800cf9db7 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -1715,6 +1715,17 @@ static void qedf_setup_fdmi(struct qedf_ctx *qedf)
> 	    FW_MAJOR_VERSION, FW_MINOR_VERSION, FW_REVISION_VERSION,
> 	    FW_ENGINEERING_VERSION);
> 
> +	snprintf(fc_host_vendor_identifier(lport->host),
> +	    FC_VENDOR_IDENTIFIER, "%s", "Marvell");
> +
> +	fc_host_num_discovered_ports(lport->host) = DISCOVERED_PORTS;
> +	fc_host_port_state(lport->host) = FC_PORTSTATE_ONLINE;
> +	fc_host_max_ct_payload(lport->host) = MAX_CT_PAYLOAD;
> +	fc_host_num_ports(lport->host) = NUMBER_OF_PORTS;
> +	fc_host_bootbios_state(lport->host) = 0X00000000;
> +	snprintf(fc_host_bootbios_version(lport->host),
> +	     FC_SYMBOLIC_NAME_SIZE, "%s", "Unknown");
> +
> }

Above changes seems like adding port attribute to transport. 
Did not quite get the RHBA/RPA addition here? Am I missing something? 

> 
> static int qedf_lport_setup(struct qedf_ctx *qedf)
> -- 
> 2.18.2
> 

--
Himanshu Madhani	 Oracle Linux Engineering

