From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH -mm] mpt fusion: Shut up uninitialized variable warnings
Date: Wed, 5 Sep 2007 17:55:09 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7096C0F7@NAMAIL4.ad.lsil.com>
References: <alpine.LFD.0.999.0709030148590.29617@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35586 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221AbXIEXzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Sep 2007 19:55:38 -0400
Content-class: urn:content-classes:message
In-Reply-To: <alpine.LFD.0.999.0709030148590.29617@enigma.security.iitk.ac.in>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam@infradead.org>, linux-scsi@vger.kernel.org
Cc: James Bottomley <james.bottomley@steeleye.com>

On Sunday, September 02, 2007 2:20 PM,  Satyam Sharma wrote:
> 
> drivers/message/fusion/mptctl.c: In function 'mptctl_mpt_command':
> drivers/message/fusion/mptctl.c:1764: warning: 'bufIn.len' 
> may be used uninitialized in this function
> drivers/message/fusion/mptctl.c:1765: warning: 'bufOut.len' 
> may be used uninitialized in this function
> 
> come because gcc gets confused by some "goto" statements in 
> above function.
> The warnings have been verified to be bogus, however, the 
> function does
> initialize these later (after the offending goto's) in the 
> function anyway.
> So let's move those initializations to top of function, 
> thereby also shutting
> up these warnings.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> 


ACK, this patch is fine.   However the patch needs posting to lsml.

Eric
