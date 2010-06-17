From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 00/23] bfa: Update driver to 2.2.2.1
Date: Wed, 16 Jun 2010 17:01:21 -0700
Message-ID: <04391A4E90BB2149B010D22452FA1687D0FEA4F5@HQ-EXCH-6.corp.brocade.com>
References: <1276625932-28138-1-git-send-email-huangj@brocade.com>
 <20100616052703.GA28174@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:44758 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274Ab0FQABe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2010 20:01:34 -0400
In-Reply-To: <20100616052703.GA28174@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vinodh Ravindran <vravindr@Brocade.COM>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Krishna Gudipati <kgudipat@Brocade.com>, Akshay Mathur <amathur@brocade.com>

>
>On Tue, Jun 15, 2010 at 11:18:52AM -0700, Jing Huang wrote:
>> Hi James,
>
>So when is the promised cleanup of the big fucking mess that the driver
>is going to happen?  The quality really didn't improve since the initial
>merge, you just kept adding features.
>

We are committed to do the cleanup, we just had to change the priority a bit
due to the demands from customers/partners to enable new hardware. After
this, we will focus on cleanup until it reaches some satisfactory status. Our
cleanup effort will start on reducing the number of source files, which we
believe is the main reason making bfa driver seemingly much bigger than
other FC HBA drivers. 

