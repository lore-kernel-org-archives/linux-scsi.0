Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC261C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 15:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 427672236F
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 15:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GnBQ3HxW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgJSP1X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 11:27:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60234 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729075AbgJSP1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2020 11:27:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JFEa96059109;
        Mon, 19 Oct 2020 15:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=+5vO0iDtPMkuxj2TPfJ1WPvufDUC0QSAUiUwz4Uud3U=;
 b=GnBQ3HxWgktYg8CR+WSSZZodmBl2s2ioRTC2TXqaJFWsr99vSECKi+Eq8Y4JecWo40ZT
 cOFaeAlqGtlkdDrePa4is8mNVGdhm4qeH3Vbyehurz+utAPdYDVZprdcGM8UQEdDobHI
 YFb9BJfJyo+HAs7zU3pq41c8ucraQlQ3nH5nYQzlt8b9LrTmnNQE7Qqn8J9kxEhw3GmL
 9BOY85pQyMWKugm8ExQqGjINUHIvGgiNCDCnoZzRgkZXggixZR79ufWpFd5DNSBhiTx1
 SGX7O8iJFapwreBkdMlfeuvz2kP5uxh64SyokzkEWmAUiVMGnOIzQjAXRRbU8a79f9bN rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 347rjkp4nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 15:27:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JFEq5D011612;
        Mon, 19 Oct 2020 15:25:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 348ahv3ddp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 15:25:17 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09JFPFgr010002;
        Mon, 19 Oct 2020 15:25:16 GMT
Received: from [192.168.1.25] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 08:25:15 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 1/4] include:scsi: FDMI enhancement
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201009093631.4182-2-jhasan@marvell.com>
Date:   Mon, 19 Oct 2020 10:25:14 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <57DAB41E-1FC9-41F8-A3B1-E2C04072517E@oracle.com>
References: <20201009093631.4182-1-jhasan@marvell.com>
 <20201009093631.4182-2-jhasan@marvell.com>
To:     Javed Hasan <jhasan@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9778 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 clxscore=1015 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 9, 2020, at 4:36 AM, Javed Hasan <jhasan@marvell.com> wrote:
>=20
> All the attributes added for RHBA and RPA registration.
> Fall back mechanism is added in between RBHA V2 and
> RHBA V1 attributes. In case RHBA get failed
> for RBHA V2 attributes, then we fall back to  RHBA V1
> attributes registration.
>=20
> Signed-off-by: Javed Hasan <jhasan@marvell.com>
> ---
> include/scsi/fc_encode.h         | 249 ++++++++++++++++++++++++++++++-
> include/scsi/scsi_transport_fc.h |  25 +++-
> 2 files changed, 270 insertions(+), 4 deletions(-)
>=20
> diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
> index c6660205d73f..57aae3e25c43 100644
> --- a/include/scsi/fc_encode.h
> +++ b/include/scsi/fc_encode.h
> @@ -210,10 +210,11 @@ static inline int fc_ct_ms_fill(struct fc_lport =
*lport,
> 	struct fc_fdmi_attr_entry *entry;
> 	struct fs_fdmi_attrs *hba_attrs;
> 	int numattrs =3D 0;
> +	struct fc_host_attrs *fc_host =3D shost_to_fc_host(lport->host);
>=20
> 	switch (op) {
> 	case FC_FDMI_RHBA:
> -		numattrs =3D 10;
> +		numattrs =3D 11;
> 		len =3D sizeof(struct fc_fdmi_rhba);
> 		len -=3D sizeof(struct fc_fdmi_attr_entry);
> 		len +=3D (numattrs * FC_FDMI_ATTR_ENTRY_HEADER_LEN);
> @@ -227,8 +228,21 @@ static inline int fc_ct_ms_fill(struct fc_lport =
*lport,
> 		len +=3D FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN;
> 		len +=3D FC_FDMI_HBA_ATTR_FIRMWAREVERSION_LEN;
> 		len +=3D FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN;
> +		len +=3D FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN;
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
> 		ct =3D fc_ct_hdr_fill(fp, op, len, FC_FST_MGMT,
> -				    FC_FDMI_SUBTYPE);
> +				FC_FDMI_SUBTYPE);
>=20
> 		/* HBA Identifier */
> 		put_unaligned_be64(lport->wwpn, =
&ct->payload.rhba.hbaid.id);
> @@ -333,7 +347,7 @@ static inline int fc_ct_ms_fill(struct fc_lport =
*lport,
> 				   &entry->type);
> 		put_unaligned_be16(len, &entry->len);
> 		strncpy((char *)&entry->value,
> -			fc_host_optionrom_version(lport->host),
> +			"unknown",
> 			FC_FDMI_HBA_ATTR_OPTIONROMVERSION_LEN);
>=20
> 		/* Firmware Version */
> @@ -361,6 +375,100 @@ static inline int fc_ct_ms_fill(struct fc_lport =
*lport,
> 			"%s v%s",
> 			init_utsname()->sysname,
> 			init_utsname()->release);
> +
> +		/* Max CT payload */
> +		entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					=
FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN);
> +		len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +		len +=3D FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN;
> +		put_unaligned_be16(FC_FDMI_HBA_ATTR_MAXCTPAYLOAD,
> +				&entry->type);
> +		put_unaligned_be16(len, &entry->len);
> +		put_unaligned_be32(fc_host_max_ct_payload(lport->host),
> +				&entry->value);
> +
> +		if (fc_host->fdmi_version =3D=3D FDMI_V2) {
> +			/* Node symbolic name */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +				FC_FDMI_HBA_ATTR_MAXCTPAYLOAD_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN;
> +			=
put_unaligned_be16(FC_FDMI_HBA_ATTR_NODESYMBLNAME,
> +				&entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			strncpy((char *)&entry->value,
> +				fc_host_symbolic_name(lport->host),
> +				FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN);
> +
> +			/* Vendor specific info */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					=
FC_FDMI_HBA_ATTR_NODESYMBLNAME_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D =
FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO_LEN;
> +			=
put_unaligned_be16(FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			=
put_unaligned_be32(fc_host_num_ports(lport->host),
> +				   &entry->value);
> +
> +			/* Number of ports */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					=
FC_FDMI_HBA_ATTR_VENDORSPECIFICINFO_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_HBA_ATTR_NUMBEROFPORTS_LEN;
> +			=
put_unaligned_be16(FC_FDMI_HBA_ATTR_NUMBEROFPORTS,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			=
put_unaligned_be32(fc_host_num_ports(lport->host),
> +				   &entry->value);
> +
> +			/* Fabric name */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +				FC_FDMI_HBA_ATTR_NUMBEROFPORTS_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_HBA_ATTR_FABRICNAME_LEN;
> +			put_unaligned_be16(FC_FDMI_HBA_ATTR_FABRICNAME,
> +				&entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			=
put_unaligned_be64(fc_host_fabric_name(lport->host),
> +			   &entry->value);
> +
> +			/* BIOS version */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +				FC_FDMI_HBA_ATTR_FABRICNAME_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_HBA_ATTR_BIOSVERSION_LEN;
> +			put_unaligned_be16(FC_FDMI_HBA_ATTR_BIOSVERSION,
> +				&entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +				strncpy((char *)&entry->value,
> +				fc_host_bootbios_version(lport->host),
> +				FC_FDMI_HBA_ATTR_BIOSVERSION_LEN);
> +
> +			/* BIOS state */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					=
FC_FDMI_HBA_ATTR_BIOSVERSION_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_HBA_ATTR_BIOSSTATE_LEN;
> +			put_unaligned_be16(FC_FDMI_HBA_ATTR_BIOSSTATE,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			=
put_unaligned_be32(fc_host_bootbios_state(lport->host),
> +				   &entry->value);
> +
> +			/* Vendor identifier  */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +				FC_FDMI_HBA_ATTR_BIOSSTATE_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_HBA_ATTR_VENDORIDENTIFIER_LEN;
> +			=
put_unaligned_be16(FC_FDMI_HBA_ATTR_VENDORIDENTIFIER,
> +				&entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			strncpy((char *)&entry->value,
> +				fc_host_vendor_identifier(lport->host),
> +				FC_FDMI_HBA_ATTR_VENDORIDENTIFIER_LEN);
> +		}
> +
> 		break;
> 	case FC_FDMI_RPA:
> 		numattrs =3D 6;
> @@ -373,6 +481,25 @@ static inline int fc_ct_ms_fill(struct fc_lport =
*lport,
> 		len +=3D FC_FDMI_PORT_ATTR_MAXFRAMESIZE_LEN;
> 		len +=3D FC_FDMI_PORT_ATTR_OSDEVICENAME_LEN;
> 		len +=3D FC_FDMI_PORT_ATTR_HOSTNAME_LEN;
> +
> +
> +		if (fc_host->fdmi_version =3D=3D FDMI_V2) {
> +			numattrs +=3D 10;
> +
> +			len +=3D FC_FDMI_PORT_ATTR_NODENAME_LEN;
> +			//Port name already added in RPA1

Fix incorrect comment style.=20

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
> +
> +		}
> +
> 		ct =3D fc_ct_hdr_fill(fp, op, len, FC_FST_MGMT,
> 				    FC_FDMI_SUBTYPE);
>=20
> @@ -461,6 +588,122 @@ static inline int fc_ct_ms_fill(struct fc_lport =
*lport,
> 			strncpy((char *)&entry->value,
> 				init_utsname()->nodename,
> 				FC_FDMI_PORT_ATTR_HOSTNAME_LEN);
> +
> +
> +		if (fc_host->fdmi_version =3D=3D FDMI_V2) {
> +
> +			/* Node name */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					FC_FDMI_PORT_ATTR_HOSTNAME_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_NODENAME_LEN;
> +			put_unaligned_be16(FC_FDMI_PORT_ATTR_NODENAME,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			=
put_unaligned_be64(fc_host_node_name(lport->host),
> +				   &entry->value);
> +
> +			/* Port name  */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					FC_FDMI_PORT_ATTR_NODENAME_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_PORTNAME_LEN;
> +			put_unaligned_be16(FC_FDMI_PORT_ATTR_PORTNAME,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			put_unaligned_be64(lport->wwpn,
> +				   &entry->value);
> +
> +			/* Port symbolic name */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					FC_FDMI_PORT_ATTR_PORTNAME_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN;
> +			=
put_unaligned_be16(FC_FDMI_PORT_ATTR_SYMBOLICNAME,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			strncpy((char *)&entry->value,
> +				fc_host_symbolic_name(lport->host),
> +				FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN);
> +
> +			/* Port type */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					=
FC_FDMI_PORT_ATTR_SYMBOLICNAME_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_PORTTYPE_LEN;
> +			put_unaligned_be16(FC_FDMI_PORT_ATTR_PORTTYPE,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			=
put_unaligned_be32(fc_host_port_type(lport->host),
> +				   &entry->value);
> +
> +			/* Supported class of service */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					FC_FDMI_PORT_ATTR_PORTTYPE_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D =
FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC_LEN;
> +			=
put_unaligned_be16(FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			=
put_unaligned_be32(fc_host_supported_classes(lport->host),
> +				   &entry->value);
> +
> +			/* Port Fabric name */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					=
FC_FDMI_PORT_ATTR_SUPPORTEDCLASSSRVC_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_FABRICNAME_LEN;
> +			put_unaligned_be16(FC_FDMI_PORT_ATTR_FABRICNAME,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			=
put_unaligned_be64(fc_host_fabric_name(lport->host),
> +				   &entry->value);
> +
> +			/* Port active FC-4 */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					=
FC_FDMI_PORT_ATTR_FABRICNAME_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN;
> +			=
put_unaligned_be16(FC_FDMI_PORT_ATTR_CURRENTFC4TYPE,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			memcpy(&entry->value, =
fc_host_active_fc4s(lport->host),
> +		       FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN);
> +
> +			/* Port state */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					=
FC_FDMI_PORT_ATTR_CURRENTFC4TYPE_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_PORTSTATE_LEN;
> +			put_unaligned_be16(FC_FDMI_PORT_ATTR_PORTSTATE,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			=
put_unaligned_be32(fc_host_port_state(lport->host),
> +				   &entry->value);
> +
> +			/* Discovered ports */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					=
FC_FDMI_PORT_ATTR_PORTSTATE_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_DISCOVEREDPORTS_LEN;
> +			=
put_unaligned_be16(FC_FDMI_PORT_ATTR_DISCOVEREDPORTS,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			=
put_unaligned_be32(fc_host_num_discovered_ports(lport->host),
> +				   &entry->value);
> +
> +			/* Port ID */
> +			entry =3D (struct fc_fdmi_attr_entry *)((char =
*)entry->value +
> +					=
FC_FDMI_PORT_ATTR_DISCOVEREDPORTS_LEN);
> +			len =3D FC_FDMI_ATTR_ENTRY_HEADER_LEN;
> +			len +=3D FC_FDMI_PORT_ATTR_PORTID_LEN;
> +			put_unaligned_be16(FC_FDMI_PORT_ATTR_PORTID,
> +				   &entry->type);
> +			put_unaligned_be16(len, &entry->len);
> +			put_unaligned_be32(fc_host_port_id(lport->host),
> +				   &entry->value);
> +		}
> +
> 		break;
> 	case FC_FDMI_DPRT:
> 		len =3D sizeof(struct fc_fdmi_dprt);
> diff --git a/include/scsi/scsi_transport_fc.h =
b/include/scsi/scsi_transport_fc.h
> index 1c7dd35cb7a0..d718a54bb0fb 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -482,10 +482,11 @@ enum fc_host_event_code  {
>  * managed by the transport w/o driver interaction.
>  */
>=20
> +#define FC_VENDOR_IDENTIFIER	8
> #define FC_FC4_LIST_SIZE		32
> #define FC_SYMBOLIC_NAME_SIZE		256
> #define FC_VERSION_STRING_SIZE		64
> -#define FC_SERIAL_NUMBER_SIZE		80
> +#define FC_SERIAL_NUMBER_SIZE		64
>=20
> struct fc_host_attrs {
> 	/* Fixed Attributes */
> @@ -497,6 +498,10 @@ struct fc_host_attrs {
> 	u32 supported_speeds;
> 	u32 maxframe_size;
> 	u16 max_npiv_vports;
> +	u32 max_ct_payload;
> +	u32 num_ports;
> +	u32 num_discovered_ports;
> +	u32 bootbios_state;
> 	char serial_number[FC_SERIAL_NUMBER_SIZE];
> 	char manufacturer[FC_SERIAL_NUMBER_SIZE];
> 	char model[FC_SYMBOLIC_NAME_SIZE];
> @@ -505,6 +510,9 @@ struct fc_host_attrs {
> 	char driver_version[FC_VERSION_STRING_SIZE];
> 	char firmware_version[FC_VERSION_STRING_SIZE];
> 	char optionrom_version[FC_VERSION_STRING_SIZE];
> +	char vendor_identifier[FC_VENDOR_IDENTIFIER];
> +	char bootbios_version[FC_SYMBOLIC_NAME_SIZE];
> +
>=20
> 	/* Dynamic Attributes */
> 	u32 port_id;
> @@ -537,6 +545,9 @@ struct fc_host_attrs {
>=20
> 	/* bsg support */
> 	struct request_queue *rqst_q;
> +
> +	/* FDMI support version*/
> +	u8 fdmi_version;
> };
>=20
> #define shost_to_fc_host(x) \
> @@ -616,6 +627,18 @@ struct fc_host_attrs {
> 	(((struct fc_host_attrs *)(x)->shost_data)->devloss_work_q)
> #define fc_host_dev_loss_tmo(x) \
> 	(((struct fc_host_attrs *)(x)->shost_data)->dev_loss_tmo)
> +#define fc_host_max_ct_payload(x)  \
> +	(((struct fc_host_attrs *)(x)->shost_data)->max_ct_payload)
> +#define fc_host_vendor_identifier(x)  \
> +	(((struct fc_host_attrs *)(x)->shost_data)->vendor_identifier)
> +#define fc_host_num_discovered_ports(x)  \
> +	(((struct fc_host_attrs =
*)(x)->shost_data)->num_discovered_ports)
> +#define fc_host_num_ports(x)  \
> +	(((struct fc_host_attrs *)(x)->shost_data)->num_ports)
> +#define fc_host_bootbios_version(x)  \
> +	(((struct fc_host_attrs *)(x)->shost_data)->bootbios_version)
> +#define fc_host_bootbios_state(x)  \
> +	(((struct fc_host_attrs *)(x)->shost_data)->bootbios_state)
>=20
> /* The functions by which the transport class and the driver =
communicate */
> struct fc_function_template {
> --=20
> 2.18.2
>=20

Other than the incorrect comment style this patch looks good.=20

You can add my R-B once you have addressed the comment.=20

--
Himanshu Madhani	 Oracle Linux Engineering

