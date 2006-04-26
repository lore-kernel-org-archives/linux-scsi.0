From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: Re: [PATCH] sas transport sysfs write attributes bug fix
Date: Tue, 25 Apr 2006 23:18:02 -0600
Message-ID: <001301c668f0$cb1887a0$1a1015ac@ericmoore>
References: <20060425233528.GA9238@lsil.com> <1146009448.3529.65.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43408 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932378AbWDZFSD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Apr 2006 01:18:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday, April 25, 2006 5:57 PM, James Bottomley wrote:

> Heh, that's a bit of a screw up in the templates (cut and paste error, I
> think), but isn't this the simpler fix?
> 

Agreed.

Yes, it would be simpler if we didn't bother with the store and show pointer
from SETUP_TEMPLATE.  I'm sure the i struct would of been already initialized
by now, and corresponding store/show fields would be set accordingly.

Regards,
Eric




