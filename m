From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: target-pending updated to v3.7-rc2
Date: Fri, 26 Oct 2012 17:31:14 -0700
Message-ID: <1351297874.13631.54.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41082 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2J0AbR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2012 20:31:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi folks,

This is a just friendly heads up that target-pending has been updated to
latest v3.7-rc2 mainline code.  As usual, the for-next* branches have
been recreated from master and include in-flight target development
patches destined for upstream during the v3.8 merge window.

Also, a heads up for bleeding edge users of for-next/auto-next branches.
There are some SCSI reservations related items that still need to be
resolved for-3.8 code, so please be careful when using SCSI reservations
logic with the current bleeding edge target-pending code.

Thanks!

--nab



