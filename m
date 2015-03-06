From: Olaf Hering <olaf@aepfle.de>
Subject: Re: use dedicated storage for scsi_debug LUNs
Date: Fri, 6 Mar 2015 16:06:47 +0100
Message-ID: <20150306150647.GA21639@aepfle.de>
References: <20150305153338.GA16293@aepfle.de>
 <54F8C923.5010202@interlog.com>
 <20150306091128.GA30096@aepfle.de>
 <yq1wq2ucnwt.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:39430 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbbCFPGu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 10:06:50 -0500
Content-Disposition: inline
In-Reply-To: <yq1wq2ucnwt.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Fri, Mar 06, Martin K. Petersen wrote:

> I agree with Doug. The target code is much more comprehensive than
> scsi_debug. You can set up file/disk/ram-backed SCSI LUNs on your
> machine without the need for any hardware .

Does that target code offer what scsi_debug offers, a bunch of stuff
listable with 'lsscsi'? The latter can be passed to backstores/pscsi.

Olaf
