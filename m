From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 9/9] isci: add version number
Date: Mon, 1 Aug 2011 20:40:00 +0200
Message-ID: <20110801204000.6fb23b4f@stein>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
	<20110730001721.28430.28086.stgit@localhost6.localdomain6>
	<20110730185507.7b68c0a7@stein>
	<CAA9_cmfnSVdohf5bkfXjZvsa+O2vjvVdy2RA=f2EfVYeXdkX+Q@mail.gmail.com>
	<20110801193806.57dc9b58@stein>
	<1312221286.8212.29.camel@mulgrave>
	<20110801202916.3d78752f@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:54545 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1HASkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 14:40:15 -0400
In-Reply-To: <20110801202916.3d78752f@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dan Williams <dan.j.williams@intel.com>

On Aug 01 Stefan Richter wrote:
> My random sample of 46 loaded modules on a desktop PC
> contains 3 drivers whose modinfo | grep -E '^version' is nonempty
> (pata_atiixp, sg, r8169).

With compiled-in drivers:  6 out of 77 feature a /sys/module/*/version
(ahci, libata, pata_atiixp, r8169, sg, tcp_cubic; calling themselves 3.0,
3.00, 0.4.6, 2.3LK-NAPI, 3.5.34, 2.3 although they are all at version 3.0).
-- 
Stefan Richter
-=====-==-== =--- ----=
http://arcgraph.de/sr/
