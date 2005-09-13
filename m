From: Anton Blanchard <anton@samba.org>
Subject: Re: [2.6.14-rc1] sym scsi boot hang
Date: Wed, 14 Sep 2005 03:13:12 +1000
Message-ID: <20050913171312.GB26353@krispykreme>
References: <20050913124804.GA5008@in.ibm.com> <20050913131739.GD26162@krispykreme> <20050913142939.GE26162@krispykreme> <1126629345.4809.36.camel@mulgrave> <20050913164727.GA26353@krispykreme> <1126632760.4809.38.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:10661 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S964928AbVIMRnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 13:43:20 -0400
Content-Disposition: inline
In-Reply-To: <1126632760.4809.38.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>


> That trace says the ibmvscsi driver (not sym2) has lost an I/O

Yep, this is another machine. The sym2 box is hanging at boot also.
Ill get a backtrace on it next.

Anton
