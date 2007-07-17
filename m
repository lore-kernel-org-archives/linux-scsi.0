From: Frank Hempel <lists@frankoni.net>
Subject: Re: aic7xxx: tape always rewinds since linux-2.6.15
Date: Tue, 17 Jul 2007 22:36:53 +0200
Message-ID: <469D2865.7030906@frankoni.net>
References: <469CFD36.4090306@frankoni.net> <Pine.LNX.4.64.0707172217560.6665@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rom173.server4you.de ([62.75.222.246]:47409 "EHLO
	ursus.sytes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbXGQUg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 16:36:58 -0400
In-Reply-To: <Pine.LNX.4.64.0707172217560.6665@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Kai Makisara schrieb:
> The device /dev/st0 is usually the auto-rewind device and, by definition, 
> the tape is rewound after the device is closed. You should use /dev/nst0 
> if you don't want the tape to be rewound after close.
> 

To use /dev/st0 instead of /dev/nst0 was the stupidity. Sorry then for 
the noise...but thanks for the help!

Frank.
