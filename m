From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/2] Add SATA support to libsas
Date: Fri, 11 Aug 2006 04:52:42 -0400
Message-ID: <44DC455A.2090705@garzik.org>
References: <44DBE943.4080303@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:53398 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750914AbWHKIwq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Aug 2006 04:52:46 -0400
In-Reply-To: <44DBE943.4080303@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

Darrick J. Wong wrote:
> Hook the scsi_host_template functions in libsas to delegate
> functionality to libata when appropriate.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

One piece that seems to be distinctly absent is controlling the SATA 
phy, rather than faking it...

	Jeff



