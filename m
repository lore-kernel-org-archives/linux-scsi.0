From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Wed, 11 Jul 2012 15:48:00 +0200
Message-ID: <4FFD8410.7050604@matthiasprager.de>
References: <4FE454CA.6080007@matthiasprager.de> <4FFAED4F.3080100@matthiasprager.de> <4FFB32E5.1050109@farcaster.org> <4FFB7354.8040809@matthiasprager.de> <4FFB8A86.7000009@farcaster.org> <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:42377 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab2GKNsI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2012 09:48:08 -0400
In-Reply-To: <4FFD6F3D.2030708@matthiasprager.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Trace <maillist@farcaster.org>
Cc: Matthias Prager <linux@matthiasprager.de>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>

I just tested kernel version 3.4.4 without commit
85ef06d1d252f6a2e73b678591ab71caad4667bb and it also works fine (beware
of commit 62d3c5439c534b0e6c653fc63e6d8c67be3a57b1 as it conflicts with
reverting 85ef06d1d252f6a2e73b678591ab71caad4667bb).

I'm trying to understand why this commit leads to the issue of i/o
failing on spun down drives, in hopes of being able to fix it. Meanwhile
maybe Tejun Heo (author of the commit) or Jens Axboe (the committer) are
able to shed some light on this (I've included them in the CC list).

Matthias
