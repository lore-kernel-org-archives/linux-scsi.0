From: HighPoint Linux Team <linux@highpoint-tech.com>
Subject: Re: [PATCH][SCSI] hptiop: add more adapter models and other fixes
Date: Tue, 11 Dec 2007 11:07:37 +0800
Message-ID: <475DFEF9.6060006@highpoint-tech.com>
References: <200712101354.53575.linux@highpoint-tech.com> <20071210165030.GB26334@parisc-linux.org>
Reply-To: linux@highpoint-tech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.biz.mail.mud.yahoo.com ([68.142.200.253]:37529 "HELO
	smtp105.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751669AbXLKDHg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Dec 2007 22:07:36 -0500
In-Reply-To: <20071210165030.GB26334@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com

Matthew Wilcox wrote:
 >> - add more PCI device IDs
 >> - support for adapters based on Marvell IOP
 >
 > Are you sure it's a good idea to do this?  This patch is 1200 lines long
 > ... the same size as the existing driver:
 >
 > $ wc drivers/scsi/hptiop.*
 >   947  2273 24531 drivers/scsi/hptiop.c
 >   256   612  6175 drivers/scsi/hptiop.h
 >   1203  2885 30706 total
 >
 > That suggests to me there's not much commonality between the two drivers,
 > and you'd be better off adding a second driver for the 4xxx cards

The new adapter implementation adds to the driver about 300 lines of
code (some lines in the original driver was changed slightly to accommodate
the difference). It is only different from the original models on the
messaging interface, and still shares same firmware command block
structures and work flow.

HighPoint Linux Team

