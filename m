From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 0/4] libosd: Last updates for Linux 2.6.30-rc
Date: Sun, 19 Apr 2009 18:58:58 +0300
Message-ID: <49EB4A42.9030502@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37372 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760561AbZDSP7G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Apr 2009 11:59:06 -0400
Received: by ewy24 with SMTP id 24so842307ewy.37
        for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2009 08:59:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: Dan Carpenter <error27@gmail.com>

Hi dear James, list

I would like to push these 3 patches to support OSD2 revision 5 wire
format, for the Linux 2.6.30-rcx series. So to minimize the maintainability
headache of having two Kernel versions with two separate wire formats.
(Pretending to be OSD2)

I have finally fixed the OSC's osd-target code to support OSD2 up to
revision 5, and am able to push these changes to the Linux initiator.
(Users will need the new HEAD at osd-target git-tree:
  git://git.open-osd.org/osc-osd master)

Revision 5 is suppose to be the very last changes to OSD2 wire format,
and is in general frozen state that should only accept fixes to the wording
of the text, if any exist.

The very first patch is a BUG fix sent by Dan Carpenter found with "smatch",
followed by three patches to fix the wire format for support of revision 5.
Only the very last patch actually changes the wire format, the first two
only refactor the code in preparation of the actual change.

Here is the list of patches:

[PATCH 1/4] potential ERR_PTR dereference in osd_initiator.c

[PATCH 2/4] libosd: OSD2r05: Prepare for rev5 attribute list changes
[PATCH 3/4] libosd: OSD2r05: OSD_CRYPTO_KEYID_SIZE will grow 20 => 32 bytes
[PATCH 4/4] libosd: OSD2r05: on-the-wire changes for latest OSD2 draft.

Please see last patch for summery of what changed.

Thanks in advance
Boaz
