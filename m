From: Erno Kovacs <erno.kovacs@freemail.hu>
Subject: Re[2]: MVSAS status
Date: Wed, 10 Feb 2010 10:53:20 +0100
Message-ID: <941837442.20100210105320@freemail.hu>
References: <loom.20100210T002935-813@post.gmane.org> <333bc7e11002100122m5eb97d7ey78a31df91dee2405@mail.gmail.com> <alpine.DEB.1.10.1002101038300.31777@uplift.swm.pp.se>
Reply-To: Erno Kovacs <erno.kovacs@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1250
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viefep33-int.chello.at ([62.179.121.51]:14558 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab0BJKIw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2010 05:08:52 -0500
Received: from edge05.upcmail.net ([192.168.13.212])
          by viefep11-int.chello.at
          (InterMail vM.7.09.01.00 201-2219-108-20080618) with ESMTP
          id <20100210095325.BLWR10757.viefep11-int.chello.at@edge05.upcmail.net>
          for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2010 10:53:25 +0100
In-Reply-To: <alpine.DEB.1.10.1002101038300.31777@uplift.swm.pp.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

> WHen I used those patches I get panics when hotswapping drives and I think
> people say it won't work with SMART either? So they seem to need more work
> to be included in regular kernel?

Regular IO, raid5/6 and SMART works fine here but I have the same bad
experience when hotplugging SATA drives.

Erno

