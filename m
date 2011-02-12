From: Fubo Chen <fubo.chen@gmail.com>
Subject: target: Question about transport_generic_allocate_tasks()
Date: Sat, 12 Feb 2011 15:33:45 +0100
Message-ID: <AANLkTi=HhpMKKW6J7R5GR2yQ_V=222TeR1KKRpUp-Z0V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61062 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab1BLOdq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Feb 2011 09:33:46 -0500
Received: by iwn9 with SMTP id 9so3359086iwn.19
        for <linux-scsi@vger.kernel.org>; Sat, 12 Feb 2011 06:33:45 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Target drivers assume that transport_generic_allocate_tasks() returns
0, -1 or -2. But if transport_generic_allocate_tasks() invoks
transport_generic_cmd_sequencer() and if
transport_generic_cmd_sequencer() invokes core_alua_state_check() the
value 1 can be returned. Which is correct - drivers or core ? And what
is meaning of return values ?

Fubo.
