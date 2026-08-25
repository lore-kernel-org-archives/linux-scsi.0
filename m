Received: from out203-205-221-191.mail.qq.com (out203-205-221-191.mail.qq.com [203.205.221.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ABA3ED5C9;
	Tue, 25 Aug 2026 09:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787649430; cv=none; b=KZIuj7CJXEmHy1ziM2XnExec+2kPEm7pREET7tPafDMtJ3wtS9S6saCi0Q7f4a3jkMVmWpHmInJM1fupMAuRalrojc5wvR+05MIFbQ7z9JrAIYDBMII4MbNy9AVOD86xtdWRaOjvq/GQvYS2ZYKZbybcWACBrU9OEgGdg50B/8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787649430; c=relaxed/simple;
	bh=PeysLjeJbnAEECANd68FkaW6zaswjbf3M4PEeOvY/G8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=TTwCM0ADbJNTKDhGZ2ZcROaDjRmyO8lPUKHu6xa+kQrxY42frcevR8Di81BWtTtoiJxLn872y+/QEwnG1KWyp6wwbdN1paPyCUudR6AL4qDXsMywYY/cZkW6Uv6frKnhlrJptB3Hm9GiLDS/pBgvpfobN1DZE3a+oP6XBGh+I+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=FYtGsRrM; arc=none smtp.client-ip=203.205.221.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="FYtGsRrM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787649425; bh=PeysLjeJbnAEECANd68FkaW6zaswjbf3M4PEeOvY/G8=;
	h=Date:To:Cc:From:Subject;
	b=FYtGsRrM4O/OsFDLXps1r+csrSnr/gD7f5gkMbxyPvCz1FTFM6R0uY3NKrVzzbqfs
	 AG+E6zHFACaAUy7ASrCzzGcwZIV3orNk14Dw20N9O/JqQu9zuirXSTaBGmiYYhvf2U
	 3dP9YwoND34Hyt10ebtfUSxvG5BcqjOcuDbT6oxs=
Received: from [192.168.255.10] ([111.206.145.19])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 4431C4F0; Tue, 25 Aug 2026 17:17:03 +0800
X-QQ-mid: xmsmtpt1787649423tbqzswl3x
Message-ID: <tencent_8474863975241BC16B538C2A14C29BE0CC05@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3JuAhq98qzNpZOhZ8uTmqJhpsnJDYA8PFDPQXWeMKH+BuYyZqKJgL
	 6jhCpHY2m9iB+o5gTFUaVhbQUYLYZ9dDi9++MQB5gNwEYoyQmtb8shsFyjIYShi1aTGn98HXNjEH
	 c5K4UVX1JNecRiK2Lhe6MrmIObRFC8R5JFX98CZ1UsS8Bpb6V1ztWFA6uPx98rLwrxJY7Omiooxl
	 k//68s6RD0+5ehFMt/3Id/7JKNB/5M+SPxZipre6B5/hrasYZp49G+MDp9uoUKnMCW4ApoUx/5mC
	 02XImUs/XyCb4meaDvtSWoHTuXdqwQCf+OO5omaIyRxEoP8UFd5ylMcraOhk9oiCBgDZGvOVawVf
	 E1AT7tg4fk057TmOIX592jQLe4dpRvh1PRWj1BkXA55PG+veyQt92N9+yWbuHj5H01LOcS8hiBpt
	 mFEthH7ueV59ftqOxRg8MBBke0o9EWNHgKB2FRwsW1o9fQdYQ1swnRzuhpNqTFIqeQOhRcQpFCgd
	 /UfjPtRY3Cih2v3h6Eu81DJe//Lc5LtmTUJIjGPRfpXIVJtelRiQoFyMp+r4Sz5dmW641Goh69Ln
	 /sWrr5Y7v6n7xWX/FUdzMwXNtkev+YnW31YHd2GgJZ7Sjpr0xWRHkE4ZW40Rrn1yzvf8AyyzynIB
	 UNsPQGJeh7398a5aNrte1+i7fG24YxuKztQJ5Ynf9pXd8R7ssK3/u8jTn8AURuTNxiutEiyjcckv
	 BZNUHGZ/KC4s9sVQk3A0k/d7LusZtJcaN9Zehy9R3S2QX6TdIsvnzfirr37z+H+MPhoQEqVet61T
	 rGslBVtK+PcNdvdXR+Xg5PqpE5dkJN+7RZScx0sw8aMBM5Pd68Q3uUIsKvh/FP/nwLFwrPqcKM7C
	 ++AfR98oJC91/1SDohVxlzPu34YnIrb4QmIKzpbyG7vVMe/2skVxAoXezNPYasSDP6Pd5q9CZhdm
	 y1L8gqi9u0IXaq7od1MfpyLbuhQ9s++yRjmc3ajAgLrePVcfmE8WMdrxwSCTP0HJxp+11J3fk1Uo
	 vB9DpdGTfvpVk7k1St4vOfLiMVGMusWqskxcBSR6XDjBHNyBKC9VGbGE95kIP2C+MT9oOI7WnDLI
	 8qN9Ii7fW34H5R4YQ+LUFBwEi2vmSYsZ+DjorNlbJtr54dkQEf72k1eDkpUltAZDzhJPN2
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-OQ-MSGID: <fd419942-4f08-4b9b-8381-ad86e9314853@qq.com>
Date: Tue, 25 Aug 2026 17:17:02 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: njavali@marvell.com, mrangankar@marvell.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
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


