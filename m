Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4427C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Sep 2021 11:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95090610CF
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Sep 2021 11:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351121AbhIDLZC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Sep 2021 07:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234482AbhIDLZB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 4 Sep 2021 07:25:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 478A3610A2
        for <linux-scsi@vger.kernel.org>; Sat,  4 Sep 2021 11:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630754640;
        bh=ULQaT41GI4P+Xwlz+bHduJLGkrnImTTKVSV930Kla8k=;
        h=From:To:Subject:Date:From;
        b=VXN1Jn2IJ7jEuR2rJOeDji5xV8IrEED+Zaxi5J2onsTf02VOeVgVIZsXzzhgUHw7K
         c6/l7765QnpTws6+5ETo2deZ5r3czrdCayqesULpTh+hEI35toMF38xGmh0QJwjvf3
         VSx5Q97WuwtMvI5uiMdhxBPczHoxgnGJhVnQRxXLPhp/WlHTiboagV5nir2MGt8reS
         vDw4fJIV0rpORRzvPwIV1t2XbL32cgBvCY1pgLTY4p60Sb90raCMFoUsfHLvNfIck3
         iUow1QO2u1WFBhfov4smrgMnOjVUHP++6Lzc2A86+h+LcZ0Cd33fOcO/RlSA+5bbzg
         H2+tNG5srnpeA==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 214311] New: megaraid_sas - no disks detected
Date:   Sat, 04 Sep 2021 11:23:59 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: jarek@poczta.srv.pl
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-214311-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D214311

            Bug ID: 214311
           Summary: megaraid_sas - no disks detected
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.10.0
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: jarek@poczta.srv.pl
        Regression: No

Dell R340 with PERC H330 - disks not detected.

lspci:

02:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS-3 3008
[Fury] (rev 02)

dmesg:

megaraid_sas 0000:02:00.0: Performance mode :Latency
megaraid_sas 0000:02:00.0: FW supports sync cache: No
megaraid_sas 0000:02:00.0: megasas_disable_intr_fusion is called
outband_intr_mask:0x40000009
megaraid_sas 0000:02:00.0: Ignore DCMD timeout: megasas_get_ctrl_info 5274
megaraid_sas 0000:02:00.0: Could not get controller info. Fail from
megasas_init_adapter_fusion 1865
megaraid_sas 0000:02:00.0: Failed from megasas_init_fw 6406

This machine works OK with kernel 4.19.0. Debian 11, Clonezilla 2.7.3-19 do=
es
not detect disks.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=
