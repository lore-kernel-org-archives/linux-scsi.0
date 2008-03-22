From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 9010] SCSI device is not offlined properly and tries to
	cache data from previous device
Date: Sat, 22 Mar 2008 17:25:34 -0500
Message-ID: <1206224734.4393.26.camel@localhost.localdomain>
References: <20080322115227.EB80F10803D@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51285 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbYCVWZh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Mar 2008 18:25:37 -0400
In-Reply-To: <20080322115227.EB80F10803D@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

On Sat, 2008-03-22 at 04:52 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> Hotplug works fine on my ICH7 ports, it's just that damn jmicron controller. So
> it must be an effect trigered by a hardware or firmware "feature".
> 
> So finally someone from libata has to fix this problem?

I think so ... I don't rule out it's being caused by one of the libata
specific pieces in SCSI, but the analysis of the problem definitely has
to begin in libata.

> thanks for the explanation

You're welcome.

James


