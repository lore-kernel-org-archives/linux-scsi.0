From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: use dedicated storage for scsi_debug LUNs
Date: Fri, 06 Mar 2015 10:28:13 -0500
Message-ID: <yq1oao6cfhu.fsf@sermon.lab.mkp.net>
References: <20150305153338.GA16293@aepfle.de> <54F8C923.5010202@interlog.com>
	<20150306091128.GA30096@aepfle.de>
	<yq1wq2ucnwt.fsf@sermon.lab.mkp.net>
	<20150306150647.GA21639@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29739 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbbCFP2T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 10:28:19 -0500
In-Reply-To: <20150306150647.GA21639@aepfle.de> (Olaf Hering's message of
	"Fri, 6 Mar 2015 16:06:47 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

>>>>> "Olaf" == Olaf Hering <olaf@aepfle.de> writes:

Olaf> Does that target code offer what scsi_debug offers, a bunch of
Olaf> stuff listable with 'lsscsi'? The latter can be passed to
Olaf> backstores/pscsi.

Yes.

-- 
Martin K. Petersen	Oracle Linux Engineering
