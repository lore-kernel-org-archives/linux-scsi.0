From: "Robert Tarte" <robt@PacificCodeWorks.com>
Subject: RE: aic94xx panic on module insertion
Date: Tue, 11 Jul 2006 01:05:06 -0700
Message-ID: <16C8363E16D7234AB844FDB52D4AEA650C2DB5@ntserv.PacificCodeWorks.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h-67-101-118-101.snfccasy.covad.net ([67.101.118.101]:407 "EHLO
	PacificCodeWorks.com") by vger.kernel.org with ESMTP
	id S1750711AbWGKIAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2006 04:00:39 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, linux-scsi <linux-scsi@vger.kernel.org>


> These comments have no direct bearing on the panic that
> James is reporting, but ... that sequencer version:
> "Razor_10a1" is old and should be updated.

[Tarte, Robert] I apologize for posting from this account, but my VPN
access is down.  There is patch available the updates the sequencer in
aic94xx to the latest version.  It is fairly ugly, because it is full of
sequencer hex.  I don't believe that this is related to James' problem.
Mike and Alexis have tried it out and it seems to running fine.  Doug,
Are you just developing on Luben's kernel, or would you like me to send
you the patch?

> 
> With a 48300 adapter I needed to do two things:
>   [a] update the board's BIOS firmware from build 1618
>       to 1705 (20060421) [See adaptec's site]
>   [b] update the linux driver's copy of the sequencer
>       code (in my case from Razor_10c2 to Razor_10c5b)
> 


