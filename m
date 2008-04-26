From: Keith Hopkins <vger@hopnet.net>
Subject: Re: AIC94xx SAS question.
Date: Sat, 26 Apr 2008 12:58:18 +0800
Message-ID: <4812B66A.5000105@hopnet.net>
References: <20080421231940.GB5656@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [221.221.248.150] ([221.221.248.150]:7410 "EHLO mail.hopnet.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbYDZFJE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2008 01:09:04 -0400
In-Reply-To: <20080421231940.GB5656@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-scsi@vger.kernel.org

On 04/22/2008 07:19 AM, Wakko Warner wrote:
> Can either of these be done:
> 1) Embed the firmware into the driver so that it can be used before the
> rootfs id mounted.

I think this is generally not done because firmware tends to be closed-source.

> 2) Can the firmware be loaded in an initr{d,amfs}?

Sure.  openSuSE does it in their mkinitrd.

--Keith
