From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] i2o: convert to use the data buffer accessors
Date: Wed, 13 Jun 2007 11:44:14 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01AB8C46@otce2k301.adaptec.com>
References: <20070614004106F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:34113 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbXFMPoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 11:44:16 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070614004106F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Since Markus removed himself from the maintenance of this driver ... I
will offer my ACK if he is truly absent since this driver is apparently
primarily in support of the legacy Babylon class of I2O adapters from
DPT and Adaptec.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of FUJITA Tomonori
> Sent: Wednesday, June 13, 2007 11:41 AM
> To: James.Bottomley@SteelEye.com
> Cc: linux-scsi@vger.kernel.org
> Subject: [PATCH] i2o: convert to use the data buffer accessors
