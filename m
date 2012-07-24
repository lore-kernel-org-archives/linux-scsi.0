From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Wed, 25 Jul 2012 00:04:26 +0200
Message-ID: <500F1BEA.8010104@matthiasprager.de>
References: <4FFB8A86.7000009@farcaster.org> <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de> <4FFD8410.7050604@matthiasprager.de> <20120717180932.GB2878@google.com> <5005BF7D.2050703@matthiasprager.de> <20120717200136.GC24336@google.com> <500A9D7C.8080801@matthiasprager.de> <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com> <500C8938.2080607@matthiasprager.de> <20120723152619.GD6823@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:56793 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab2GXWEd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2012 18:04:33 -0400
In-Reply-To: <20120723152619.GD6823@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Robert Trace <maillist@farcaster.org>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, Eric Moore <Eric.Moore@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>, Matthias Prager <linux@matthiasprager.de>

Hello everyone,

I retested with a new firmware (P14 - released today), since it contains
a bunch of sata and SATL fixes (according to the changelog).
Unfortunately the observed behavior is unchanged (tested on a 3.4.5 kernel).

Just wanted to let everyone know.

Cheers
Matthias
