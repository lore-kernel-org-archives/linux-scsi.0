From: Anil Kumar <anilsr@gmail.com>
Subject: module insert question
Date: Wed, 23 Feb 2005 21:03:24 -0800
Message-ID: <d3a6bba0050223210312d93aee@mail.gmail.com>
Reply-To: Anil Kumar <anilsr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from rproxy.gmail.com ([64.233.170.207]:42082 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261825AbVBXFDZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2005 00:03:25 -0500
Received: by rproxy.gmail.com with SMTP id a41so225650rng
        for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2005 21:03:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: anilsr@gmail.com

Hi,

Can you please let me know, what all files does the OS look into to
load modules?
I see the following messages during boot rather installation:
======
Finished bus probing
modules to insert tg3 aic79xx
======

which files does the OS look into to load tg3 and aic79xx after
finishing bus probing. I guess modprobe.conf, modules.alias,
modules.pcimap.

with regards,
    Anil
