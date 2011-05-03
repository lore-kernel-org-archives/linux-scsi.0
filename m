From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: writing "- - -" to /sys/class/scsi_host/...
Date: Tue, 03 May 2011 12:54:47 +0200
Message-ID: <4DBFFB17020000A100005C59@gwsmtp1.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:38428 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1ECKyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2011 06:54:55 -0400
Received: from rrzmta2.uni-regensburg.de (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id A0AA03883
	for <linux-scsi@vger.kernel.org>; Tue,  3 May 2011 12:54:52 +0200 (CEST)
Received: from gwsmtp1.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
	by rrzmta2.uni-regensburg.de (Postfix) with ESMTP id 904053806
	for <linux-scsi@vger.kernel.org>; Tue,  3 May 2011 12:54:52 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I was trying to find out the meaning of "- - -" in the magic command to scan a SCSI host. After finding the code in the sources (after extensive searching), I'm wondering (2.6.16.60, scsi_sysfs.c):

static int check_set(unsigned int *val, char *src)
{
        char *last;

        if (strncmp(src, "-", 20) == 0) {
                *val = SCAN_WILD_CARD;
        } else {
[...]

If it's still there in the current sources, does that "20" do anything useful? The comparison should end at the second character anyway. "-" is always zero-terminated. Did I miss something?

Regards,
Ulrich
P.S. Please CC me if your reply should reach me, I'm not subscribed in the list!

