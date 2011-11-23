From: Justin Maggard <jmaggard10@gmail.com>
Subject: NetWare issues
Date: Tue, 22 Nov 2011 18:57:32 -0800
Message-ID: <CAKgsxVSTsGg0J2Y+voadgczFjmZYiLXRmhXDbSQJ3HF9PUiUZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33149 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab1KWC5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2011 21:57:33 -0500
Received: by ggnr5 with SMTP id r5so939936ggn.19
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2011 18:57:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm seeing an issue where connecting to the kernel iSCSI target from a
NetWare 6.5 initiator can easily take down the machine hosting the
target.  NetWare 6.5 seems to ignore the random StatSN set in
iscsi_login_set_conn_values(), and always uses 1.  At that point,
iSCSI I/O causes rapid memory use increases by the target, and you
start getting OOMs pretty quickly.  Has anyone else run into this?
I've tried several target versions, and they all seem to do it.

Thanks,
-Justin
