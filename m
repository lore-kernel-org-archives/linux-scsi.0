From: James Smart <James.Smart@Emulex.Com>
Subject: RE: [PATCH v3 10/20] lpfc: Fix provide host name and OS name in
 RSNN-NN FC-GS command
Date: Wed, 22 Apr 2015 00:40:34 +0000
Message-ID: <C56D4DEB4BD07946B93F4A90B4FE3FC75A31DC1C@CMEXMB1.ad.emulex.com>
References: <55242ae6.b7GjnkXu1bXVHKz1%james.smart@emulex.com>
	<20150415000218.00007e7c@localhost>
	<55327B0B.2010009@emulex.com>,<20150422011525.00001d22@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:48836 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933519AbbDVAlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 20:41:00 -0400
In-Reply-To: <20150422011525.00001d22@localhost>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Primarily emulex applications that display san connectivity.  There are also some Switch mgmt suites that at least display this information. Not sure how much they act on it.

-- james s


________________________________________
From: Sebastian Herbszt [herbszt@gmx.de]
Sent: Tuesday, April 21, 2015 7:15 PM
To: James Smart
Cc: linux-scsi@vger.kernel.org; Sebastian Herbszt
Subject: Re: [PATCH v3 10/20] lpfc: Fix provide host name and OS name in RSNN-NN FC-GS command

James Smart wrote:
> Fixes those things that parse the result of what data is registered with
> the fabric.
>
> -- james

Any particular "thing" you got on your mind?
qla2xxx does not provide this information (yet).

Sebastian
