From: christophe varoqui <christophe.varoqui@free.fr>
Subject: HSV : ghosts & multipath
Date: Tue, 12 Aug 2003 01:03:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F3820C9.4060004@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.wanadoo.fr ([193.252.22.26]:60965 "EHLO
	mwinf0503.wanadoo.fr") by vger.kernel.org with ESMTP
	id S274889AbTHKXDu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 19:03:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: evan.felix@pnl.gov
Cc: linux-scsi@vger.kernel.org

Hello,

I read your contribution to scsidev, regarding HSV.
You seem to have an intimate knowledge of these controlers.
Do you happen to have a clue on how to force the activation of a ghost 
LUN from a Linux host ?

The rationale being : in a multipath config, when all active path are 
exhausted you should be able to activate the ghosts paths rather than 
let the device die.

More generally, how do you manage access to your HSV LUNs ? I personnaly 
would hate to use SecurePath which locks the user to one distribution 
and has not passed the "community peer-review test". Any alternative 
applicable in a dual fabric, dual attached hosts & controlers (4 
paths/host including 2 ghosts : 2 paths through the left fabric, 2 paths 
through the right) ?

