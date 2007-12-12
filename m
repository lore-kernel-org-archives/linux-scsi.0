From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry indirectory) (fwd)
Date: Wed, 12 Dec 2007 08:25:10 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0101052210@otce2k301.adaptec.com>
References: <20071129130319.GA2642@atrey.karlin.mff.cuni.cz> <20071129235813Y.tomof@acm.org> <20071129164557.GD30957@1und1.de> <20071130021226T.tomof@acm.org>  <20071130103450.GC7697@1und1.de> <1197384034.19679.13.camel@n2o.xs4all.nl> <1197409983.6288.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:49483 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbXLLN1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Dec 2007 08:27:41 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1197409983.6288.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>, Anders Henke <anders.henke@1und1.de>
Cc: FUJITA Tomonori <tomof@acm.org>, matthew@wil.cx, jack@ucw.cz, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

ACK, patch looks good. Thanks for composing this patch. Glad to hear of
successful test results.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Miquel 
> van Smoorenburg
. . .
> 
> I just recompiled 2.6.23.9 with the 64 bit patch for dpt_i2o 
> and now it
> boots just fine.
> 
> The patch is here:
> http://www.miquels.cistron.nl/linux/dpt_i2o-64bit-2.6.23.patch
> 
> It's not the final version - it needs a few cleanups before it can be
> submitted, but perhaps you can test if it also works for you.
> 
> Mike.
