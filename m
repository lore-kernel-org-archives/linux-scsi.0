From: "Thomas A. Szybist" <tszybist@comcast.net>
Subject: Probe order on multi-channel Adaptec cards
Date: Wed, 22 Oct 2003 22:05:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031022220509.A15735@carmina.verona01.nj.comcast.net>
Reply-To: tszybist@comcast.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:24548 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S261566AbTJWCFM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 22:05:12 -0400
Received: (from szybist@localhost)
	by carmina.localdomain (8.11.2/8.11.2) id h9N259X16145
	for linux-scsi@vger.kernel.org; Wed, 22 Oct 2003 22:05:09 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On multi-channel Adaptec cards, channel "A" always comes up first.

Many motherboard controllers are multi-channel and have channel "B"
as the internal bus.  This creates problems when attaching storage to
the external bus, (channel A), since those devices attach before the
internal devices.  This is troublesome if the boot device is on the
internal bus (channel B).

The "reverse_scan" option and disabling the bios work well if one has
two separate cards, but they don't seem to effect the multi-channel
probe order.

Is there anyway to do this?

For aic79xx I have driver 1.3.4
For aic7xxx I have driver 6.2.36

Thanks,

Tom
