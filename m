From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently
 on 2.6.8.1
Date: Sun, 31 Jul 2005 19:54:59 +0200
Message-ID: <42ED1073.7010004@s5r6.in-berlin.de>
References: <Pine.LNX.4.44.0507310739320.13193-100000@sasami.anime.net> <42ED0AE6.7020300@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:3016 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261820AbVGaRzQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 13:55:16 -0400
In-Reply-To: <42ED0AE6.7020300@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

PS: Documentation/scsi/scsi_mid_low_api.txt suggests:

> An LLD that detects the removal of a SCSI device can instigate
> its removal from upper layers with this sequence:
> 
>                   SCSI DEVICE hot unplug
> LLD                      mid level                 LLD
> ===----------------------=========-----------------===------
> scsi_remove_device() -------+
>                             |
>                      slave_destroy()
> ------------------------------------------------------------

Well, the LLD can _try_ it, but it may go horribly wrong.
-- 
Stefan Richter
-=====-=-=-= -=== =====
http://arcgraph.de/sr/
