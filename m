From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Multi-Initiator SAS
Date: Wed, 20 Sep 2006 16:17:43 -0700
Message-ID: <4511CC17.4020307@us.ibm.com>
References: <664A4EBB07F29743873A87CF62C26D7032CDC0@NAMAIL4.ad.lsil.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:47494 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750817AbWITXRp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 19:17:45 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7032CDC0@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Moore, Eric wrote:

> Which expander are you using?  I believe James has some sata work
> arounds
> for the sasx12, which has byte ordering issues.

A Vitesse VSC7160.

Also, I think I might have complained about I/O errors accessing the
SATA disk via mptsas--the SATA disk that we were using (Maxtor 6Y080M0)
yields the same errors when attached to the HBA.  I put in a Hitachi
SATA disk and it was fine with both controllers.

--D
