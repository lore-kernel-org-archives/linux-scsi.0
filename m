From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] aic94xx: Don't call pci_map_sg for already-mapped	scatterlists
Date: Tue, 05 Dec 2006 12:38:58 -0800
Message-ID: <4575D8E2.3070708@us.ibm.com>
References: <4555206C.8010909@us.ibm.com> <1165338091.2785.8.camel@mulgrave.il.steeleye.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:41754 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968687AbWLEUjF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 15:39:05 -0500
In-Reply-To: <1165338091.2785.8.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

James Bottomley wrote:

> Rather than introduce an extra flag, I think we can key of the protocol
> flag:  libata is the only thing that initiates STP tasks.  How does this
> look?

ACK.

--D
