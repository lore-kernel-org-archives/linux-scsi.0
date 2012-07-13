From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 1/1] aacraid: Series 7 Async. (performance) mode support
Date: Fri, 13 Jul 2012 10:44:12 +0100
Message-ID: <1342172652.3039.19.camel@dabdike.int.hansenpartnership.com>
References: <1341993401-6205-1-git-send-email-Mahesh_Rajashekhara@pmc-sierra.com>
	 <1342167984.3039.5.camel@dabdike.int.hansenpartnership.com>
	 <340C71CD25A7EB49BFA81AE8C83926671952C074@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56207 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754891Ab2GMJoR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jul 2012 05:44:17 -0400
In-Reply-To: <340C71CD25A7EB49BFA81AE8C83926671952C074@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh_Rajashekhara@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, Achim Leubner <Achim_Leubner@pmc-sierra.com>, Tony Ruiz <Tony_Ruiz@pmc-sierra.com>

On Fri, 2012-07-13 at 02:39 -0700, Mahesh Rajashekhara wrote:
> Hi James,
> 
> We downloaded the upstream aacraid sources from "git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git". Looks
> like Endian fix patches are not available. Can you please send us the
> current pointer to download sources? So that, we rebuild our Series 7
> Async performance driver patch over them.

They are in that repository on the misc branch:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=commit;h=e1d77a3a5d30f45ec3ef1be12a812171f1e64fa4

et seq.

James


