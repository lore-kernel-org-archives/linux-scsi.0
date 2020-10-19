Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CA5C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 16:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6B69222B9
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 16:02:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ygHgmYXO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgJSQC0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 12:02:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50612 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730335AbgJSQCZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 12:02:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JG06Io117222;
        Mon, 19 Oct 2020 16:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=tTeSezEp3szEHlLZf52rcORV0EOgik0kPcdVZ/jJdqg=;
 b=ygHgmYXO7tl+/OkYV7wEuUxPX1d8/sGUcBUHfLi9UUXaSTHOqRjIAaQgH8ZkG3jBZNza
 4KmCqL1KjUUyBsTxYTFFSjwCzNm5f7KUGuBWER77/wY4AjDKS8zti32AaYCct2+0rrJY
 6RVFYIui88P8mnSSDi8NLXne19zpKQzhMlDoudiEx3X6XUe9QQqmMgkKBp4BXAhCQY+2
 +TtrxY9wEKUZ6lTD10GOw+to7Rc8EughULtlYjM032N2Sq2hXYupxcTKk51jjcHS+2fb
 j7Wm2Y8w+VJlwBIcdp3VziVhSwPRgQKTAMjPsE3kmhiCVdihJdSRaaVAKUx9y0p6wPXT kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 347s8mpa8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 16:02:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JFxwBb192075;
        Mon, 19 Oct 2020 16:02:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 348a6m2pe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 16:02:21 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09JG2L9s027261;
        Mon, 19 Oct 2020 16:02:21 GMT
Received: from [192.168.1.25] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 09:02:20 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 3/4] scsi:libfc: FDMI enhancement.
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201009093631.4182-4-jhasan@marvell.com>
Date:   Mon, 19 Oct 2020 11:02:20 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C21CA752-1CC8-41AB-ADB4-014755FA4927@oracle.com>
References: <20201009093631.4182-1-jhasan@marvell.com>
 <20201009093631.4182-4-jhasan@marvell.com>
To:     Javed Hasan <jhasan@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1011 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010190110
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 9, 2020, at 4:36 AM, Javed Hasan <jhasan@marvell.com> wrote:
>=20
> Added all the attributes for RHBA and RPA registration.
> Fall back mechanism is added in between RBHA V2 and
> RHBA V1 attributes. In case RHBA get failed
> for RBHA V2 attributes, then we fall back to  RHBA V1
> attributes registration.
>=20
> Signed-off-by: Javed Hasan <jhasan@marvell.com>
> ---
> drivers/scsi/libfc/fc_lport.c | 64 +++++++++++++++++++++++++++++++----
> 1 file changed, 58 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/libfc/fc_lport.c =
b/drivers/scsi/libfc/fc_lport.c
> index b84dbc316df1..9b32930b5c67 100644
> --- a/drivers/scsi/libfc/fc_lport.c
> +++ b/drivers/scsi/libfc/fc_lport.c
> @@ -1185,7 +1185,7 @@ static void fc_lport_ms_resp(struct fc_seq *sp, =
struct fc_frame *fp,
> 	struct fc_lport *lport =3D lp_arg;
> 	struct fc_frame_header *fh;
> 	struct fc_ct_hdr *ct;
> -
> +	struct fc_host_attrs *fc_host =3D shost_to_fc_host(lport->host);
> 	FC_LPORT_DBG(lport, "Received a ms %s\n", fc_els_resp_type(fp));
>=20
> 	if (fp =3D=3D ERR_PTR(-FC_EX_CLOSED))
> @@ -1219,7 +1219,13 @@ static void fc_lport_ms_resp(struct fc_seq *sp, =
struct fc_frame *fp,
>=20
> 		switch (lport->state) {
> 		case LPORT_ST_RHBA:
> -			if (ntohs(ct->ct_cmd) =3D=3D FC_FS_ACC)
> +			if ((ntohs(ct->ct_cmd) =3D=3D FC_FS_RJT) && =
fc_host->fdmi_version =3D=3D FDMI_V2) {
> +				FC_LPORT_DBG(lport, "Error for FDMI-V2, =
fall back to FDMI-V1\n");
> +				fc_host->fdmi_version =3D FDMI_V1;
> +
> +				fc_lport_enter_ms(lport, LPORT_ST_RHBA);
> +
> +			} else if (ntohs(ct->ct_cmd) =3D=3D FC_FS_ACC)
> 				fc_lport_enter_ms(lport, LPORT_ST_RPA);
> 			else /* Error Skip RPA */
> 				fc_lport_enter_scr(lport);
> @@ -1433,7 +1439,7 @@ static void fc_lport_enter_ms(struct fc_lport =
*lport, enum fc_lport_state state)
> 	int size =3D sizeof(struct fc_ct_hdr);
> 	size_t len;
> 	int numattrs;
> -
> +	struct fc_host_attrs *fc_host =3D shost_to_fc_host(lport->host);
> 	lockdep_assert_held(&lport->lp_mutex);
>=20
> 	FC_LPORT_DBG(lport, "Entered %s state from %s state\n",
> @@ -1446,10 +1452,10 @@ static void fc_lport_enter_ms(struct fc_lport =
*lport, enum fc_lport_state state)
> 	case LPORT_ST_RHBA:
> 		cmd =3D FC_FDMI_RHBA;
> 		/* Number of HBA Attributes */
> -		numattrs =3D 10;
> +		numattrs =3D 11;
> 		len =3D sizeof(struct fc_fdmi_rhba);
> 		len -=3D sizeof(struct fc_fdmi_attr_entry);
> -		len +=3D (numattrs * FC_FDMI_ATTR_ENTRY_HEADER_LEN);
> +
> 		len +=3D FC_FDMI_HBA_ATTR_NODENAME_LEN;
> 		len +=3D FC_FDMI_HBA_ATTR_MANUFACTURER_LEN;
> 		len +=3D FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN;
> @@ -1460,6 +1466,21 @@ static void fc_lport_enter_ms(struct fc_lport =
*lport, enum fc_lport_state state)
> 		len +=3D FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN;
> 		len +=3D FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN;
> 		len +=3D FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN;
> +		len +=3D FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN;
> +
> +
> +		if (fc_host->fdmi_version =3D=3D FDMI_V2) {
> +			numattrs +=3D 7;
> +			len +=3D FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN;
> +			len +=3D =
FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO_LEN;
> +			len +=3D FC_FDMI_HBA_ATTR_NUMBEROFPORTS_LEN;
> +			len +=3D FC_FDMI_HBA_ATTR_FABRICNAME_LEN;
> +			len +=3D FC_FDMI_HBA_ATTR_BIOSVERSION_LEN;
> +			len +=3D FC_FDMI_HBA_ATTR_BIOSSTATE_LEN;
> +			len +=3D FC_FDMI_HBA_ATTR_VENDORIDENTIFIER_LEN;
> +		}
> +
> +		len +=3D (numattrs * FC_FDMI_ATTR_ENTRY_HEADER_LEN);
>=20
> 		size +=3D len;
> 		break;
> @@ -1469,7 +1490,6 @@ static void fc_lport_enter_ms(struct fc_lport =
*lport, enum fc_lport_state state)
> 		numattrs =3D 6;
> 		len =3D sizeof(struct fc_fdmi_rpa);
> 		len -=3D sizeof(struct fc_fdmi_attr_entry);
> -		len +=3D (numattrs * FC_FDMI_ATTR_ENTRY_HEADER_LEN);
> 		len +=3D FC_FDMI_PORT_ATTR_FC4TYPES_LEN;
> 		len +=3D FC_FDMI_PORT_ATTR_SUPPORTEDSPEED_LEN;
> 		len +=3D FC_FDMI_PORT_ATTR_CURRENTPORTSPEED_LEN;
> @@ -1477,6 +1497,22 @@ static void fc_lport_enter_ms(struct fc_lport =
*lport, enum fc_lport_state state)
> 		len +=3D FC_FDMI_PORT_ATTR_OSDEVICENAME_LEN;
> 		len +=3D FC_FDMI_PORT_ATTR_HOSTNAME_LEN;
>=20
> +		if (fc_host->fdmi_version =3D=3D FDMI_V2) {
> +			numattrs +=3D 10;
> +			len +=3D FC_FDMI_PORT_ATTR_NODENAME_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_PORTNAME_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_PORTTYPE_LEN;
> +			len +=3D =
FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_FABRICNAME_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_PORTSTATE_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_DISCOVEREDPORTS_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_PORTID_LEN;
> +		}
> +
> +		len +=3D (numattrs * FC_FDMI_ATTR_ENTRY_HEADER_LEN);
> +
> 		size +=3D len;
> 		break;
> 	case LPORT_ST_DPRT:
> @@ -1546,6 +1582,7 @@ static void fc_lport_timeout(struct work_struct =
*work)
> 	struct fc_lport *lport =3D
> 		container_of(work, struct fc_lport,
> 			     retry_work.work);
> +	struct fc_host_attrs *fc_host =3D shost_to_fc_host(lport->host);
>=20
> 	mutex_lock(&lport->lp_mutex);
>=20
> @@ -1573,6 +1610,13 @@ static void fc_lport_timeout(struct work_struct =
*work)
> 		fc_lport_enter_fdmi(lport);
> 		break;
> 	case LPORT_ST_RHBA:
> +		if (fc_host->fdmi_version =3D=3D FDMI_V2) {
> +			FC_LPORT_DBG(lport, "timeout for FDMI-V2 =
RHBA,fall back to FDMI-V1\n");
> +			fc_host->fdmi_version =3D FDMI_V1;
> +			fc_lport_enter_ms(lport, LPORT_ST_RHBA);
> +			break;
> +		}
> +		fallthrough;
> 	case LPORT_ST_RPA:
> 	case LPORT_ST_DHBA:
> 	case LPORT_ST_DPRT:
> @@ -1839,6 +1883,13 @@ EXPORT_SYMBOL(fc_lport_config);
>  */
> int fc_lport_init(struct fc_lport *lport)
> {
> +	struct fc_host_attrs *fc_host;
> +
> +	fc_host =3D shost_to_fc_host(lport->host);
> +
> +	/* Set FDMI version to FDMI-2 specification*/
> +	fc_host->fdmi_version =3D FDMI_V2;
> +
> 	fc_host_port_type(lport->host) =3D FC_PORTTYPE_NPORT;
> 	fc_host_node_name(lport->host) =3D lport->wwnn;
> 	fc_host_port_name(lport->host) =3D lport->wwpn;
> @@ -1847,6 +1898,7 @@ int fc_lport_init(struct fc_lport *lport)
> 	       sizeof(fc_host_supported_fc4s(lport->host)));
> 	fc_host_supported_fc4s(lport->host)[2] =3D 1;
> 	fc_host_supported_fc4s(lport->host)[7] =3D 1;
> +	fc_host_num_discovered_ports(lport->host) =3D 4;
>=20
> 	/* This value is also unchanging */
> 	memset(fc_host_active_fc4s(lport->host), 0,
> --=20
> 2.18.2
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

