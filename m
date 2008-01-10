From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Thu, 10 Jan 2008 01:53:01 +0100
Message-ID: <47856C6D.3020909@s5r6.in-berlin.de>
References: <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain> <20080109174945.GB15346@one.firstfloor.org> <4785138A.4000809@s5r6.in-berlin.de> <4785304A.60109@gmail.com> <20080109205850.GU16309@parisc-linux.org> <47853FA7.9050506@s5r6.in-berlin.de> <20080109222308.GE15612@one.firstfloor.org> <478552DF.1050203@s5r6.in-berlin.de> <20080110003806.GD18480@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:59030 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYAJAxJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 19:53:09 -0500
In-Reply-To: <20080110003806.GD18480@one.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jon Watte <jwatte@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Andi Kleen wrote:
> On Thu, Jan 10, 2008 at 12:03:59AM +0100, Stefan Richter wrote:
>>> Kconfig is also not an educational facility or high level
>>> design description of the code, but a pragmatic tool to get the job
>>> done.
>> I did not talk about education or design decription.  I did talk about
>> appropriately showing what the Kconfig options do.
> 
> That's "high level design description"

...of the Kconfig option.

But it's not a "design description of the code" which we are
configuring.  (Even though intelligent beings might be able to draw
conclusions about the code, based on what config options are offered.)
-- 
Stefan Richter
-=====-==--- ---= -=-=-
http://arcgraph.de/sr/
