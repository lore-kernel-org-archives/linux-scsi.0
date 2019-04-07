From: Ondrej Zary <linux@zary.sk>
Subject: [RFC PATCH 0/2] fdomain: Resurrect driver
Date: Sun,  7 Apr 2019 20:56:15 +0200
Message-ID: <20190407185617.8467-1-linux@zary.sk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Rik Faith <faith@cs.unc.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,
the removal of fdomain driver caused regressions:
https://alioth-lists.debian.net/pipermail/sane-devel/2019-January/036552.html

I've got a fdomain-based AHA-2920A card so I'll try to resurrect the driver
and then clean it up.
