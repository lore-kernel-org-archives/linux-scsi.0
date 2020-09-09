Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D10DC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 16:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4616E21532
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 16:09:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sfLmRvUK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgIIQJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 12:09:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53416 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730785AbgIIQJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 12:09:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089Do0ax174607;
        Wed, 9 Sep 2020 13:51:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=91TJN7g+YPWfra47Ab5rgxvnR4TcCTlMsk1+DsrAabM=;
 b=sfLmRvUKF85fNTyWBb946N9LzKPr1tNu/ZMrRKtLSzdxKo1tibza8oa3yZUfXp2OgkAj
 hsyq4UK9kExmJr0sH2kXNEdL7K4u+2cBuWyWGYifrERm7wtdkljzhPxSaZPdoTcL0ITB
 QAp8nazOhIF7YbwZdLbu5EuzUrKvYj4CS7Th0FUcOvIiiMjB3eZNngKZODaErAuCnS8I
 7imQwYDiI/o5GiPnDpNrCmvaFv6cgEta84h5OzEoWEYRjlh24FRdUKU7WciQ2t+5Dqwx
 yiDx/+9NomqeGbJ/BLVhRP5XPnEk3WS7xNKONI8AoGwhH2RbdL1LnLzne6s7VtkUeo8t LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33c3an1s7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 13:51:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089DpUA0020773;
        Wed, 9 Sep 2020 13:51:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33cmeswwv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 13:51:49 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 089Dpmgw023473;
        Wed, 9 Sep 2020 13:51:48 GMT
Received: from dhcp-10-154-140-107.vpn.oracle.com (/10.154.140.107)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 06:51:48 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH 2/2] scsi: fc: Update documentation of sysfs nodes for
 FPIN stats
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200730061116.20111-3-njavali@marvell.com>
Date:   Wed, 9 Sep 2020 08:51:48 -0500
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <AF2CA7B1-045B-4197-AE6A-D5121A2AC424@oracle.com>
References: <20200730061116.20111-1-njavali@marvell.com>
 <20200730061116.20111-3-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=3 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=3 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090124
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 30, 2020, at 1:11 AM, Nilesh Javali <njavali@marvell.com> =
wrote:
>=20
> From: Shyam Sundar <ssundar@marvell.com>
>=20
> Update documentation for sysfs nodes within,
>       /sys/class/fc_host
>       /sys/class/fc_remote_ports
>=20
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> Documentation/ABI/testing/sysfs-class-fc_host | 23 +++++++++++++++++++
> .../ABI/testing/sysfs-class-fc_remote_ports   | 23 +++++++++++++++++++
> 2 files changed, 46 insertions(+)
> create mode 100644 Documentation/ABI/testing/sysfs-class-fc_host
> create mode 100644 =
Documentation/ABI/testing/sysfs-class-fc_remote_ports
>=20
> diff --git a/Documentation/ABI/testing/sysfs-class-fc_host =
b/Documentation/ABI/testing/sysfs-class-fc_host
> new file mode 100644
> index 000000000000..a1e6ab89b86f
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fc_host
> @@ -0,0 +1,23 @@
> +What:		/sys/class/fc_host/hostX/statistics/fpin_cn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance =
Impact
> +		Notification (FPIN) events generated by the fabric, to =
indicate
> +		congestion detected on this host.
> +
> +What:		/sys/class/fc_host/hostX/statistics/fpin_li_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance =
Impact
> +		Notification (FPIN) events generated by the fabric, to =
indicate
> +		Link Integrity errors between the fabric and this host.
> +
> +What:		/sys/class/fc_host/hostX/statistics/fpin_dn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance =
Impact
> +		Notification (FPIN) events generated by the fabric, to =
indicate
> +		Delivery related errors between the fabric and this =
host.
> diff --git a/Documentation/ABI/testing/sysfs-class-fc_remote_ports =
b/Documentation/ABI/testing/sysfs-class-fc_remote_ports
> new file mode 100644
> index 000000000000..185db8ec6c05
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fc_remote_ports
> @@ -0,0 +1,23 @@
> +What:		=
/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_cn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance =
Impact
> +		Notification (FPIN) events generated by the fabric, to =
indicate
> +		congestion detected on this rport.
> +
> +What:		=
/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_li_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance =
Impact
> +		Notification (FPIN) events generated by the fabric, to =
indicate
> +		Link Integrity errors between the fabric and this rport.
> +
> +What:		=
/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_dn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of Fabric Performance =
Impact
> +		Notification (FPIN) events generated by the fabric, to =
indicate
> +		Delivery related errors between the fabric and this =
rport.
> --=20
> 2.19.0.rc0
>=20

Looks Good to me.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

