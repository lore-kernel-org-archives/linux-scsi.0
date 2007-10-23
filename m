From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: Target mode support for qlogic chipsets isp2422/2432/5422/5432
Date: Tue, 23 Oct 2007 04:27:21 -0700
Message-ID: <471DDA99.5050309@qlogic.com>
References: <3b8510d80710230117l269c6356uff350caeb1ee0e31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:28266 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbXJWL0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 07:26:05 -0400
In-Reply-To: <3b8510d80710230117l269c6356uff350caeb1ee0e31@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thayumanavar Sachithanantham <thayumk@gmail.com>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <tomof@acm.org>

Thayumanavar Sachithanantham wrote:
> Hi All,
> 
> Does the recent target mode support added for tgt support target mode
> for qla chipset (qla24xx series)?
I'm in the middle of adding the target mode support for qla24xx and newer series on top of the recent target mode patch (submitted by Tomonori).
As an estimate, the patch will be submitted within a couple of weeks.

> Can anyone say what isp chipset qla2462 belong to? ( i don't have 2462
> with this and i need this info if possible).
The QLA2462 has a ISP2422.

Thank you,
Seokmann
