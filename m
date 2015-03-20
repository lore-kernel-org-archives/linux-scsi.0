From: Olaf Hering <olaf@aepfle.de>
Subject: Re: use dedicated storage for scsi_debug LUNs
Date: Fri, 20 Mar 2015 13:07:31 +0100
Message-ID: <20150320120731.GA11391@aepfle.de>
References: <20150305153338.GA16293@aepfle.de>
 <54F8C923.5010202@interlog.com>
 <20150306091128.GA30096@aepfle.de>
 <yq1wq2ucnwt.fsf@sermon.lab.mkp.net>
 <20150306150647.GA21639@aepfle.de>
 <yq1oao6cfhu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:58398 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbCTMHd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2015 08:07:33 -0400
Content-Disposition: inline
In-Reply-To: <yq1oao6cfhu.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Fri, Mar 06, Martin K. Petersen wrote:

> >>>>> "Olaf" == Olaf Hering <olaf@aepfle.de> writes:
> Olaf> Does that target code offer what scsi_debug offers, a bunch of
> Olaf> stuff listable with 'lsscsi'? The latter can be passed to
> Olaf> backstores/pscsi.
> Yes.

Indeed, with /backstores/fileio/ and /loopback/.

It would be nice if one could specify a fixed identifier for each fileio
during creation. Right now the symlinks in /dev/disk/by-*/* are all
random. Its not easily possible to map file_or_dev=$file to the
resulting SCSI device.

Olaf
