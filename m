From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Thu, 10 Jan 2008 00:16:15 +0100
Message-ID: <478555BF.1010103@s5r6.in-berlin.de>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com> <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain> <20080109174945.GB15346@one.firstfloor.org> <4785138A.4000809@s5r6.in-berlin.de> <4785304A.60109@gmail.com> <20080109205850.GU16309@parisc-linux.org> <47853FA7.9050506@s5r6.in-berlin.de> <20080109222308.GE15612@one.firstfloor.org> <478552DF.1050203@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:55803 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYAIXQW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 18:16:22 -0500
In-Reply-To: <478552DF.1050203@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jon Watte <jwatte@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> The Kconfig menu layouts, prompts, and help texts are there to inform/
> "educate"/ guide the user when configuring the build environment, with
> the goal that he safely and efficiently gets to a working software
> configuration.

It might have been not entirely clear from my earlier postings, but I
(and others) actually made alternative suggestions how to improve the
menus.  Namely, split the SCSI menu and get to the following order of
prompts:

	"Do you have HDDs?"
	"(Then you need this option here, except in this and that very
	special case.)"

	"Do you have an IDE or SATA controller?"

	"I see your attention is beginning to slip, but let me ask one
	more thing --- do you have one of those SCSI controllers? No?
	Thought	so."

No need to use the buggy and conceptually problematic "select" keyword
anywhere.
-- 
Stefan Richter
-=====-==--- ---= -=-=-
http://arcgraph.de/sr/
