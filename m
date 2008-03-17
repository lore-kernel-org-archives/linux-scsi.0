From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 1/2] zfcp: Fix race during ERP thread shutdown
Date: Mon, 17 Mar 2008 15:19:52 +0100
Message-ID: <20080317141952.GA14110@schmichrtp.de.ibm.com>
References: <20080310151852.808020000@de.ibm.com> <20080310152328.463410000@de.ibm.com> <20080311164341.GA6380@osiris.boeblingen.de.ibm.com> <1205331227.4852.102.camel@kitka.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:45135 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbYCQOTz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 10:19:55 -0400
Content-Disposition: inline
In-Reply-To: <1205331227.4852.102.camel@kitka.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

James,

we discussed this in our team. Since the issue is not new, and nobody
was able to trigger this so far, we will drop the patch for now, until
there is a better solution.

But this does not affect the patch in "[patch 2/2] zfcp: Fix handling
for boxed port after physical close". Could you pull this one into
scsi-misc?

Christof
