From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: bidi support: FC transport layer...
Date: Thu, 10 Jul 2008 05:55:31 -0700
Message-ID: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:21255 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbYGJNKo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 09:10:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Hi,

With starting to implement FC-CT/ELS support on the qla2xxx module, I  
would like to get some idea about the bidi-bidirectional.
As I understand that the bidi is packet transporting infra-structure,  
I think it could be good candidate for the FC specific FC-CT/ELS  
packet delivery in between the application and the individual devices  
given topology.

As I have limited understanding about the bid, here are my questions,
0. would the bidi be a right choice for the FC-CT/ELS packet delivery?
1. where should I get any kind of documents/briefs about the bidi?
2. which part of code that I have to walk-through for further  
understanding about the bidi mechanism?
3. with the bidi, what's the application interface should look like?

I expect to have some changes/additions in the FC transport layer in  
regards to the support and in general.

Any comment/guidance would be greatly helpful.

Thank you,
Seokmann
