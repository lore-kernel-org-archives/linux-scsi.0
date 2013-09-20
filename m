From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi disk: Use its own buffer for the vpd request
Date: Fri, 20 Sep 2013 18:51:20 -0400
Message-ID: <yq1fvszds47.fsf@sermon.lab.mkp.net>
References: <87mwp5frdl.fsf@spindle.srvr.nix> <51F67959.2060803@fastmail.fm>
	<87fvuxdqes.fsf@spindle.srvr.nix> <yq1txjdhree.fsf@sermon.lab.mkp.net>
	<51F80167.1080004@fastmail.fm> <yq1zjt3h11y.fsf@sermon.lab.mkp.net>
	<51F94E8D.5040908@fastmail.fm> <51F95A2E.60805@fastmail.fm>
	<51FA71E2.6010501@fastmail.fm> <871u5b7azv.fsf@spindle.srvr.nix>
	<20130831015337.GA8164@kroah.com> <87d2ot1w27.fsf@spindle.srvr.nix>
	<52238A33.7020703@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39181 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3ITWvq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2013 18:51:46 -0400
In-Reply-To: <52238A33.7020703@fastmail.fm> (Bernd Schubert's message of "Sun,
	01 Sep 2013 20:40:51 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Nix <nix@esperi.org.uk>, Greg KH <greg@kroah.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, nick.cheng@areca.com.tw, stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>

>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:

[Sorry about the delay. Catching up on a couple of weeks worth of email]

Bernd> So if anything else than a Seagate drive is connected to an Areca
Bernd> controller with older firmware it will still fail.

It's just blacklisting a specific Seagate drive. However, skip_vpd_pages
is also set by USB.

I'm still completely in favor of your patch to reduce the VPD buffer
size. Please resubmit and feel free to add my Acked-by:.

-- 
Martin K. Petersen	Oracle Linux Engineering
