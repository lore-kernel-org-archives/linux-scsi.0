From: Matthew Wilcox <willy@debian.org>
Subject: Re: Badness in scsi_single_lun_run at /root/scsi/scsi_lib.c:344
Date: Wed, 28 Jan 2004 18:37:21 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040128183721.GM11844@parcelfarce.linux.theplanet.co.uk>
References: <20040127003244.GM23308@serve.riede.org> <20040128033041.GY23308@serve.riede.org> <20040128084142.A4835@beaverton.ibm.com> <20040128173609.GE23308@serve.riede.org> <20040128095341.A5242@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:30636 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266146AbUA1ShX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 13:37:23 -0500
Content-Disposition: inline
In-Reply-To: <20040128095341.A5242@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Willem Riede <wrlk@riede.org>, linux-scsi@vger.kernel.org

On Wed, Jan 28, 2004 at 09:53:41AM -0800, Patrick Mansfield wrote:
> BTW what is PD?

I've got a PD drive myself (SCSI, not IDE).  I believe it stands for
Plasmon Drive.  There's one slot on the front of the 5.25" unit which
will take either CDs or PDs.  It shows up as two LUNs.  The PD discs
are rewritable but never achieved much mass-market acceptance.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
