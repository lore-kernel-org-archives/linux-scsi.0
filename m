From: "Nate Iverson" <niverson@pillardata.com>
Subject: Where is max_scsi_adapter_scatter_gather_elements found in the Linux source code?
Date: Tue, 21 Sep 2004 10:58:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <16236EEEF4D4264DA31C2E35E3607CFE08EA22@coex02.trans.corp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.pillardata.com ([63.251.178.132]:18872 "EHLO
	mail1.pillardata.com") by vger.kernel.org with ESMTP
	id S267866AbUIUQ6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2004 12:58:44 -0400
Received: from coex01.trans.corp (coex01 [172.18.24.16])
	by mail1.pillardata.com (Postfix) with ESMTP id 539A1E5C2C
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2004 10:58:42 -0600 (MDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> In http://en.tldp.org/HOWTO/SCSI-Generic-HOWTO/dio.html it says 
> 
> Notes
> 
> [1]	Unfortunately that setup time is large enough in some versions of the lk 2.4 series to adversely impact direct IO performance. Also memory malloc()-ed in the user space tends to be made up of discontinuous pages seen from the SCSI adapter. This requires the sg driver to build heavily splintered scatter gather lists which is less than desirable. This limits the maximum transfer size to [(max_scsi_adapter_scatter_gather_elements - 1) * PAGE_SIZE]. [This is a _different_ scatter gather mechanism to that which the user sees in the sg interface based on iovec.]
> 
> 
> I have grepped through the Linux source code, but I can't find max_scsi_adapter_scatter_gather_elements. The max data transfer appears to be ~1MB on my kernel. I'm using Redhat 9 with a custom kernel I built.(4.20-8_SPARSE_16). I would like to double the max tranfer size so my target device can be forced to do iterations on large read and write command. I'm assuming changing PAGE_SIZE would cause problems for other modules.
> 
> Nathan Iverson
