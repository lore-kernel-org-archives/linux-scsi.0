From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 0/14 - 2nd post] mpt2sas: driver version 01.100.02.00
Date: Tue, 21 Apr 2009 11:25:23 -0400
Message-ID: <1240327523.9408.1.camel@mulgrave.int.hansenpartnership.com>
References: <660360F4F2570145BD872F298951B17A76BCB2F2@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58326 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841AbZDUPZ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 11:25:26 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17A76BCB2F2@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2009-04-21 at 08:08 -0700, Moore, Eric wrote:
> James - Can you please push these patchs into 2.6.30-rc ?

OK, so separate the patches into bug fixes (or -rc) and features (for
next merge window).  T10 DIF is clearly a feature as is lun reset
support and driver name in ioctl and updating the functional naming
conventions.

James


