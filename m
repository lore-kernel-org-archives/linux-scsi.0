Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EE43E0758;
	Tue, 25 Aug 2026 09:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649015; cv=none; b=dJrm/Vc+y8YfyX+qBkIxpfaiyxKJThc/DxWsYmhIyp41fHWDsudnWExjrXtIxJHOY2C+NOC1hWIgIyHHWFuePsC2vKn7V0lsXHTY5oWLesWWbPZvnCCrw2UUDqV6R9UBZDEydr0ALnChOLDWje5DgBj8MgJU8uhcUy7NVVUZmMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649015; c=relaxed/simple;
	bh=PeysLjeJbnAEECANd68FkaW6zaswjbf3M4PEeOvY/G8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=HJdwOdrBkzyKBT+scH/rbsHjBlkOVrgR510f5znsSARa+f7sesVFn+LPhizPvNmoJdiS1qRgVBImuzRMEOXOW4Y23rozuo+gtziTlmJm5wb1OzYQLv+Hsrpnoifkt2d40ksp9wWz2KzJQ5ncYcE9N3bUJ95m9P7ES4ldOt6du5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=W67fGX5R; arc=none smtp.client-ip=203.205.221.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="W67fGX5R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787649010; bh=PeysLjeJbnAEECANd68FkaW6zaswjbf3M4PEeOvY/G8=;
	h=Date:To:Cc:From:Subject;
	b=W67fGX5RQCydYWBbPoLDmTvJUFKa35Hnl6uTZCviD/5V3gWtVrVL/I3v96rbu1sep
	 jCQMuoIPt9LcV8DMODvBx84RGnEmyM5txNm3yepOx0iRT2cP7D12HNOLJ7K0wzydAZ
	 ESL9Zhjq5RnE2JSPXZ/aQ52MtuS5zf+S3XD8ZkJc=
Received: from [192.168.255.10] ([111.206.145.19])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 28826E04; Tue, 25 Aug 2026 17:10:08 +0800
X-QQ-mid: xmsmtpt1787649008tn0u5fa0i
Message-ID: <tencent_973A1BCA2B57AC33B4D37BE0EC74C6263505@qq.com>
X-QQ-XMAILINFO: OEUhVsHQax4MPp8nCAIKGj5ki1A3XXDk18QBK2r46FtMVaLJzMypxbum8OxIM8
	 TS8mLIYhzF/CHoN1ipoLUeqrN50WlBgCAIjEIZPaZxqA21ubgrhXqVlxXJVGFqDCug/i/Vibcdf2
	 NwxdDYvjrEXDOrKgiTZMwK5JoSZSt8aip3VFgknTOGdJ9Sepoof8oORFZyfQ5vW7n9wRTUYCvVIJ
	 ar3uguid8W3sU7FVipwLZvLKbFp/J3YwaLEPn5M0HDBJxqXMOdV0mpmVa77c60QAbNSz99VUVbPU
	 1db23tORlrfwWTv7Dc1rFMRne2rc++jWmkxTHQ337WYkZ3Tz+chv8i/t+qOCjtwiTaB20VhlHTr2
	 clwqoRV+m2DFgllRhlVbQC+Dsak8IHAUiFD/ky9PplIiALUJaLCoAUFepKs8VsWQbJprTsVRzuTE
	 ul282L7DlT/e2YBN+zRK12cdPDZmRsPRkNBQ1XargEDSE3vnp1bQ4vH7iJjvCz63y16c7qtXcwNV
	 twP6kIlBQiK+o7F6xqfU9yqqBMNZ9Jzv0sIEhX7DhNq0ba/xr5g5GmGv4JK9ohwJB6ZZe2IlJPs0
	 WXZxfyp495SWpEXFJZRstk4EMLPbA+BiogujJcSuo6gWpRTqiTv3/HY6E6BB/R7LwImeo7Uv2/18
	 jJc84MDh2swG1gzfb3F5FE8jKlGM02Jja4yuT+NjfK7hBoCo04qx/0pg6Lw6ZsIBcURlC96uluu8
	 aRDvZiLX/BbsTDWzW3OrXZjy0cePmMwihKym13FcRseIiiuzib/HhmD8mODuHalw3RLD5jUCj1VR
	 iHzaCxfaylb3Yo/GpA865gxetNwAqddwvJ+OWxCP3hCj/WcnemWbU04DYSo3HaR1tdiI57rnhEO/
	 mknzYtYI3bwMhGV6KWntVpczeeeFEqHc+pqv3MvevcFT9NZopVK/YrFj2PYEGVZS0cg4dQgga9V2
	 fI4Fc2qWXKjnWaEZURtkZ2mdFvwF6wWt9ek14YBHpCk+f+yQOZyo4hd20vP7wZV+PVPIw8g1vEsr
	 so2kcPbamCXHU0iopzdKuo2hGQCJPALw7BvYCelbsxQrACt3p36joPuk7X3He0Z9st3CqiLJvAui
	 VpwhoUx3Vu2O7q4mVY6ovhvI/TtA==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-OQ-MSGID: <8c03e205-a4d6-4aea-91bb-d5764c19296f@qq.com>
Date: Tue, 25 Aug 2026 17:10:07 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: njavali@marvell.com, mrangankar@marvell.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
From: Yang Zi <2959243019@qq.com>
Subject: [PATCH] scsi: qla4xxx: Fix NULL pointer dereference in
 qla4xxx_abort_active_cmds()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

qla4xxx_probe_adapter()'s failure path first calls scsi_remove_host(),
which drops the SCSI host's tag set reference and frees tag_set.tags via
scsi_mq_free_tags() -> blk_mq_free_tag_set().  It then falls through to
qla4xxx_free_adapter(), which calls qla4xxx_abort_active_cmds().  That
function walks ha->host->can_queue entries and, for each one, calls
qla4xxx_del_from_active_array() -> scsi_host_find_tag(), which
dereferences shost->tag_set.tags -- now NULL -- resulting in a NULL
pointer dereference.

KASAN report:

    BUG: KASAN: null-ptr-deref in scsi_host_find_tag include/scsi/scsi_tcq.h:33 [inline] [qla4xxx]
    BUG: KASAN: null-ptr-deref in qla4xxx_del_from_active_array drivers/scsi/qla4xxx/ql4_os.c:9095 [inline] [qla4xxx]
    BUG: KASAN: null-ptr-deref in qla4xxx_abort_active_cmds+0x10b/0x610 drivers/scsi/qla4xxx/ql4_os.c:4816 [qla4xxx]

Guard qla4xxx_abort_active_cmds() so that it returns early when the SCSI
host has not been set up yet or its tag set has already been released:
in both cases there are no outstanding commands left to abort, and
scsi_host_find_tag() must not dereference a NULL tag_set.tags pointer.
This covers both the failed-probe cleanup path and the normal
qla4xxx_remove_adapter() path.

This patch addresses two reports with the same root cause (tracking IDs
115 and 139).

Signed-off-by: Yang Zi <2959243019@qq.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d598ab4126f8..2277f48fede8 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4811,6 +4811,15 @@ static void qla4xxx_abort_active_cmds(struct scsi_qla_host *ha, int res)
     int i;
     unsigned long flags;
 
+    /*
+     * The SCSI host may not be fully set up yet, or its tag set may
+     * already have been released by scsi_remove_host().  In either case
+     * there are no outstanding commands to abort, and scsi_host_find_tag()
+     * would dereference a NULL tag_set.tags pointer.
+     */
+    if (!ha->host || !ha->host->tag_set.tags)
+        return;
+
     spin_lock_irqsave(&ha->hardware_lock, flags);
     for (i = 0; i < ha->host->can_queue; i++) {
         srb = qla4xxx_del_from_active_array(ha, i);

