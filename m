From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 2/6] bfa: replace endian swap macros with the ones
 provided by linux
Date: Tue, 19 Oct 2010 13:32:57 -0700
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A5CF75E8B7@HQ1-EXCH01.corp.brocade.com>
References: <1287447050-27777-1-git-send-email-huangj@brocade.com>
 <20101019140920.GA13348@infradead.org>
 <E5313AF6F2BFD14293E5FD0F94750F86A5CF75E89A@HQ1-EXCH01.corp.brocade.com>
 <20101019202521.GA11011@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:42115 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486Ab0JSUdq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2010 16:33:46 -0400
In-Reply-To: <20101019202521.GA11011@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

>Driver relaly should use proper annotations (endiness, __iomem and __user).
>This helps catching all kinds of really nasty bugs using the sparse
>static analysis tool.

We will fix this. Thanks.

