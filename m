From: Bjarne Thomsen <bjarne.thomsen@get2net.dk>
Subject: Re: cp from SATA to SCSI freeze
Date: Mon, 25 Oct 2004 18:08:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098720502.2547.31.camel@tycho.astronomy.dk>
References: <1098612795.11032.20.camel@tycho.astronomy.dk>
	 <417C90CB.6070909@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fitch3.uni2.net ([130.227.52.106]:58074 "EHLO fitch3.uni2.net")
	by vger.kernel.org with ESMTP id S262068AbUJYQIY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 12:08:24 -0400
Received: from [192.168.1.102] (83.72.33.52.ip.tele2adsl.dk [83.72.33.52])
	by fitch3.uni2.net (8.12.6/8.11.6) with ESMTP id i9PG8KtJ030328
	for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2004 18:08:20 +0200
In-Reply-To: <417C90CB.6070909@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, 2004-10-25 at 07:36, Jeff Garzik wrote:
> Have the latest BIOS?  BIOS update seems to fix most of the system 
> freeze issues, and replacing cables / power often fixes the rest.
> 
Yes, I have the latest BIOS (beta), but I didn't use it.
This morning I had an idea: could it be hyper transport?
The CPU2, PCI-X0, and AGP HT Link speeds were set to
600MHz or 800MHz by default.
After having changed all 3 values to 200MHz I
have not had a single freeze. I am still testing.

 -- Bjarne

-- 
Bjarne Thomsen <bjarne.thomsen@get2net.dk>
Institute of Physics & Astronomy

