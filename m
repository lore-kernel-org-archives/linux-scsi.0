Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C77DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jan 2022 13:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbiAQNxu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jan 2022 08:53:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21910 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232713AbiAQNxs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Jan 2022 08:53:48 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20H99mpd014258;
        Mon, 17 Jan 2022 05:53:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=QQUBdXG0kkdlp3Ye1CGbQsI6ZjE0upSErSTk+eVWwgg=;
 b=W0SDw/TwWEIMX+GEbq/KYuD6Jegi8BvUiL+jmyJrFpcv1tC+qHqWqRawlw7n8Tux4uVO
 J4J1ab3LJNnAVZzk+jw7PouyQEtpMXGN2CiCYYM6wVfenhyFyEjtOdImqOF8LBjtE6sL
 cbnj39L8soEcbe/IPH2f25ozv6T70E8Syl5SmRGZ4UivQSvCY11AxTqMy0TeH1YwNmj3
 zwYg5DdqbmY23V3ykg2HEXqd2VDUva2+Hy6/kfoTDeovgJZ/TJroaU+2ZlwPqJNORrFX
 UguUrttx4UMiWchbAt028f+95uYpn3MUcnYYr0MSp/3FJ4FirTFb+HTaDhck9LNcWEQQ kw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dn5gg8py1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 05:53:46 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 17 Jan
 2022 05:53:44 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 17 Jan 2022 05:53:44 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 7047D5B692E;
        Mon, 17 Jan 2022 05:53:44 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 20HDrb1C006299;
        Mon, 17 Jan 2022 05:53:37 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 20HDrBQ6006290;
        Mon, 17 Jan 2022 05:53:11 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <loberman@redhat.com>,
        <jpittman@redhat.com>, <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 0/3] qedf misc bug fixes
Date:   Mon, 17 Jan 2022 05:53:08 -0800
Message-ID: <20220117135311.6256-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Qi_FJjuaifOEujAtXenjAUqweIEyXUSj
X-Proofpoint-GUID: Qi_FJjuaifOEujAtXenjAUqweIEyXUSj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_06,2022-01-14_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please apply the qedf driver misc bug fixes to the scsi tree
at your earliest convenience.

Thanks,
Nilesh

Saurav Kashyap (3):
  qedf: Add stag_work to all the vports
  qedf: Fix refcount issue when LOGO is received during TMF
  qedf: Change context reset messages to ratelimited

 drivers/scsi/qedf/qedf_io.c   | 1 +
 drivers/scsi/qedf/qedf_main.c | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)


base-commit: 315d049ad1951cef02d9337a2469cac51cca6932
-- 
2.23.1

