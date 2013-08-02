From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi disk: Use its own buffer for the vpd request
Date: Thu, 01 Aug 2013 23:00:11 -0400
Message-ID: <yq1li4ker0k.fsf@sermon.lab.mkp.net>
References: <87r4ehfzhf.fsf@spindle.srvr.nix> <51F667C2.4020801@fastmail.fm>
	<87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net>
	<51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net>
	<51F94E8D.5040908@fastmail.fm> <51F95A2E.60805@fastmail.fm>
	<51FA71E2.6010501@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32152 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3HBDAe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Aug 2013 23:00:34 -0400
In-Reply-To: <51FA71E2.6010501@fastmail.fm> (Bernd Schubert's message of "Thu,
	01 Aug 2013 16:34:10 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Nix <nix@esperi.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw, stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>

>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:

Bernd,

Bernd> Once I noticed that scsi_get_vpd_page() works fine from other
Bernd> function calls and that it is not 0x89, but already 0x0 that
Bernd> fails fixing it became easy.

Bernd> Nix, any chance you could verify it also works for you?

Do we get an appropriate error back when we try to issue WRITE SAME
10/16? If so, I'm OK with this fix.

And thanks for looking into this!

-- 
Martin K. Petersen	Oracle Linux Engineering
