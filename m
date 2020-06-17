Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22442C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E82E721527
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgFQIyw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgFQIyw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 04:54:52 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 199435] HPSA + P420i resetting logical Direct-Access never
 complete
Date:   Wed, 17 Jun 2020 08:54:51 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: voronkovaa@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-199435-11613-ek6BdGpz9X@https.bugzilla.kernel.org/>
In-Reply-To: <bug-199435-11613@https.bugzilla.kernel.org/>
References: <bug-199435-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=199435

--- Comment #36 from Andrey Voronkov (voronkovaa@gmail.com) ---
/usr/sbin/hpssacli ctrl all show detail

Smart Array P410 in Slot 1
   Bus Interface: PCI
   Slot: 1
   Serial Number: PACCRID122902CV
   Cache Serial Number: PBCDH0CRH2K24K
   Controller Status: OK
   Hardware Revision: C
   Firmware Version: 6.64
   Rebuild Priority: Medium
   Expand Priority: Medium
   Surface Scan Delay: 3 secs
   Surface Scan Mode: Idle
   Parallel Surface Scan Supported: No
   Queue Depth: Automatic
   Monitor and Performance Delay: 60  min
   Elevator Sort: Enabled
   Degraded Performance Optimization: Disabled
   Inconsistency Repair Policy: Disabled
   Wait for Cache Room: Disabled
   Surface Analysis Inconsistency Notification: Disabled
   Post Prompt Timeout: 15 secs
   Cache Board Present: True
   Cache Status: OK
   Cache Status Details: The current array controller had valid data stored in
its battery/capacitor backed write cache the last time it was reset or was
powered up.  This indicates that the system may not have been shut down
gracefully.  The array controller has automatically written, or has attempted
to write, this data to the drives.  This message will continue to be displayed
until the next reset or power-cycle of the array controller.
   Cache Ratio: 25% Read / 75% Write
   Drive Write Cache: Disabled
   Total Cache Size: 512 MB
   Total Cache Memory Available: 400 MB
   No-Battery Write Cache: Disabled
   Cache Backup Power Source: Capacitors
   Battery/Capacitor Count: 1
   Battery/Capacitor Status: OK
   SATA NCQ Supported: True
   Number of Ports: 2 Internal only
   Driver Name: hpsa
   Driver Version: 3.4.20
   Driver Supports HPE SSD Smart Path: True
   PCI Address (Domain:Bus:Device.Function): 0000:06:00.0
   Sanitize Erase Supported: False
   Primary Boot Volume: logicaldrive 1 (600508B1001C3DAA9705279AD5D8DABA)
   Secondary Boot Volume: None

-- 
You are receiving this mail because:
You are the assignee for the bug.
