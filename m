From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Mon, 9 May 2016 22:29:45 +0300
Message-ID: <20160509192914.GJ29510@mwanda>
References: <1462668011.32105.7.camel@petros-ultrathin>
 <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
 <20160509080551.GH29510@mwanda>
 <3aced88f2434c8dd0a8aa4fd902445a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28903 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbcEITaO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2016 15:30:14 -0400
Content-Disposition: inline
In-Reply-To: <3aced88f2434c8dd0a8aa4fd902445a9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Finn Thain <fthain@telegraphics.com.au>, Petros Koutoupis <petros@petroskoutoupis.com>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

I'm confused what you are saying.  According to Petros, these bugs are
causing failures in real life, I was only added to the CC list because
Smatch should have warned about them.

regards,
dan carpenter

