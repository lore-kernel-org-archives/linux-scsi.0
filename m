From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [RFC] Common header file for FC definitions
Date: Tue, 08 Jan 2008 05:59:51 -0800
Message-ID: <478381D7.7050507@qlogic.com>
References: <20080108080924.GA6993@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:50544 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYAHN7F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 08:59:05 -0500
In-Reply-To: <20080108080924.GA6993@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Christof Schmitt wrote:
> zfcp has a couple of definitions to describe the FC protocol. Grepping
> through the complete source tree shows that e.g. the lpfc module makes
> similar private definitions. It think that it would make sense to
> introduce a global header file for FC related definitions that each FC
> driver can use.
> 
> The attached patch contains some definitons that i found in zfcp and
> could be reused by other drivers.
> 
> What do others think? Would this be useful?
This is good idea. It could be widely used for FC drivers across the vendors as their features get added.
Especially for Link Services including FC-CT protocol.

Thank you,
Seokmann
