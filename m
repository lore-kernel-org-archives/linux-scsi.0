From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Patch] Fix regression in 3.18 caused by e05fe29248 qla2xxx:
	Honor FCP_RSP retry delay timer field.
Date: Tue, 23 Dec 2014 09:32:11 +0100
Message-ID: <20141223083211.GC2303@lst.de>
References: <20141219102916.6fcae21a@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36994 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbaLWIcN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2014 03:32:13 -0500
Content-Disposition: inline
In-Reply-To: <20141219102916.6fcae21a@pluto.restena.lu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com

Chad, Saurav,

does this look ok to you?

