From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: linux-2.6.0-test11 [BUG] -- scsi_add/remove_device - out of memory
Date: Tue, 13 Jan 2004 10:11:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040113181131.GC899@beaverton.ibm.com>
References: <OF11CFD4DA.B5836830-ONC1256E1A.00322027-C1256E1A.00356646@de.ibm.com> <20040113162646.GA2550@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:11489 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S265517AbUAMSGW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 13:06:22 -0500
Content-Disposition: inline
In-Reply-To: <20040113162646.GA2550@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <Heiko.Carstens@de.ibm.com>, Adam Radford <aradford@3WARE.com>, linux-scsi@vger.kernel.org

I forgot to ask are you still seeing this failure on recent version of
2.6 as there was an issue of the scsi-mid not calling slave_destroy in
certain cases.

-andmike
--
Michael Anderson
andmike@us.ibm.com

