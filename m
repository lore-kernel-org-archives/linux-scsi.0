From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v3 10/20] lpfc: Fix provide host name and OS name in
 RSNN-NN FC-GS command
Date: Wed, 22 Apr 2015 01:15:25 +0200
Message-ID: <20150422011525.00001d22@localhost>
References: <55242ae6.b7GjnkXu1bXVHKz1%james.smart@emulex.com>
	<20150415000218.00007e7c@localhost>
	<55327B0B.2010009@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63466 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965025AbbDUXPf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 19:15:35 -0400
In-Reply-To: <55327B0B.2010009@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> Fixes those things that parse the result of what data is registered with 
> the fabric.
> 
> -- james

Any particular "thing" you got on your mind?
qla2xxx does not provide this information (yet).

Sebastian
