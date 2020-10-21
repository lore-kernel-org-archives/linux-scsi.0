Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DB5C388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 14:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D98682224E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 14:59:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iwloSGrC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443843AbgJUO7I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 10:59:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39318 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443840AbgJUO7I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 10:59:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LEmxud018119;
        Wed, 21 Oct 2020 14:59:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=1s3pdq6sblTxC1TwIPhEt3j5JJbN4eRMwySWpi0g69E=;
 b=iwloSGrCitBKhpoDqTWfLtEJC91ET6zXtn/czC2Vku0c14CZ8q0BCEtxGE6AKZh6dVLq
 3oqaTiWR6aJcUIdCvQGoFMMML/Fz/YnatEm9GRbqhGdgxevttKbFhEEpLxxTTggcMzft
 zGN41utWKLtNx/xOB4UIG+FaEPnKmLUV1wNCrmkbxH5R696yM1oGEd93OjaBe8TU+qf6
 gQiTLIUWdttTYHsq+VfDvSSPyGxPRK0ZdD1ju7+Fh6FZ2REygoMP4HTVbABw6rAgDTGI
 1SzAHi0D0mDZ5v+KjFCrJgrKz7b/UbpZeCkwF56Wxe5kFKT/AvjSbiex9VzVufew3Mg3 vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 347p4b1435-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Oct 2020 14:59:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LEneC7022290;
        Wed, 21 Oct 2020 14:57:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 348agys5yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 14:57:05 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09LEv44A031557;
        Wed, 21 Oct 2020 14:57:04 GMT
Received: from [192.168.1.6] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 07:57:04 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 5/5] scsi: fc: Update documentation of sysfs nodes for
 FPIN stats
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201021092715.22669-6-njavali@marvell.com>
Date:   Wed, 21 Oct 2020 09:57:03 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <034E3044-26EF-4F51-8F3D-50E8A0ABE6D4@oracle.com>
References: <20201021092715.22669-1-njavali@marvell.com>
 <20201021092715.22669-6-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210113
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2020, at 4:27 AM, Nilesh Javali <njavali@marvell.com> =
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
> Reviewed-by: James Smart <james.smart@broadcom.com>
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
> index 000000000000..0a696cbd8232
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fc_host
> @@ -0,0 +1,23 @@
> +What:		/sys/class/fc_host/hostX/statistics/fpin_cn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of congestion =
notification
> +		events recorded by the F_Port, reported using fabric
> +		performance impact notification (FPIN) event.
> +
> +What:		/sys/class/fc_host/hostX/statistics/fpin_li_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of link integrity error
> +		events recorded by the F_Port/Nx_Port, reported using =
fabric
> +		performance impact notification (FPIN) event.
> +
> +What:		/sys/class/fc_host/hostX/statistics/fpin_dn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of delivery related =
errors
> +		recorded by the F_Port/Nx_Port, reported using fabric
> +		performance impact notification (FPIN) event.
> diff --git a/Documentation/ABI/testing/sysfs-class-fc_remote_ports =
b/Documentation/ABI/testing/sysfs-class-fc_remote_ports
> new file mode 100644
> index 000000000000..55a951529e03
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-fc_remote_ports
> @@ -0,0 +1,23 @@
> +What:		=
/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_cn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of congestion =
notification
> +		events recorded by the F_Port/Nx_Port, reported using =
fabric
> +		performance impact notification (FPIN) event.
> +
> +What:		=
/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_li_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of link integrity error
> +		events recorded by the F_Port/Nx_Port, reported using =
fabric
> +		performance impact notification (FPIN) event.
> +
> +What:		=
/sys/class/fc_remote_ports/rport-X:Y-Z/statistics/fpin_dn_yyy
> +Date:		July 2020
> +Contact:	Shyam Sundar <ssundar@marvell.com>
> +Description:
> +		These files contain the number of delivery related =
errors
> +		recorded by the F_Port/Nx_Port, reported using fabric
> +		performance impact notification (FPIN) event.
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

