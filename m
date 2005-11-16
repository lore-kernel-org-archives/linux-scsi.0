From: Michael Renner <michael.renner@geizhals.at>
Subject: Re: Bad SCSI performance with 2.6.14 and Fusion-MPT
Date: Wed, 16 Nov 2005 22:27:55 +0100
Message-ID: <437BA45B.20809@geizhals.at>
References: <437BA36F.10600@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from home.geizhals.at ([213.229.14.34]:50629 "EHLO
	morework.geizhals.at") by vger.kernel.org with ESMTP
	id S1030476AbVKPV2B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 16:28:01 -0500
In-Reply-To: <437BA36F.10600@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-scsi@vger.kernel.org

Alan D. Brunelle wrote:

> I'm seeing what looks to be the same problem (see: U320 SCSI negotiation 
> problem in Linux 2.6.13 and later implementations on LSI Logic / Symbios 
> Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)). [[I think I 
> have a patch (perhaps suspect, but it works for me), if you're 
> interested.]]

Yeah, I'd like to see it. Interestingly another box with the same 
hardware setup and very slightly different .config works fine with 2.6.14.

best regards,
michael
