From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Scsi midlayer question
Date: Fri, 16 Jul 2004 11:24:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF31C7BA4F.BE5253F2-ON88256ED3.0063D350-88256ED3.006511B2@us.ibm.com>
References: <47F3C2BE74738E4683574107469DFA204CC4FA@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:14333 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266409AbUGPS2Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jul 2004 14:28:25 -0400
In-Reply-To: <47F3C2BE74738E4683574107469DFA204CC4FA@XYUSEX01.xyus.xyratex.com>
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: linux-scsi@vger.kernel.org

>I can see from a fibre channel trace that my 1 MB I/O transfers are
>getting cut up into little chunks.

What is "my 1 MB I/O transfer"?  How are you generating or seeing this 
transfer?  Sg device?

I ask because sometimes when I hear this question, the transfer is a 
transfer to the page cache, so it has only a loose association with 
transfers on the fibre channel.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
