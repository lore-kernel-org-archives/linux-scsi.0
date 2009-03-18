From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/3] scsi_dh: Change scsi device handler	modules	to	utilize
 modalias
Date: Wed, 18 Mar 2009 20:46:15 +0100
Message-ID: <49C14F87.2010806@s5r6.in-berlin.de>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>	 <20090318013627.26548.27704.sendpatchset@chandra-ubuntu>	 <20090318134629.GB19448@mars.virtualiron.com>	 <49C1168F.6060900@s5r6.in-berlin.de>	 <1237397158.14147.3.camel@chandra-ubuntu>	 <49C1344D.30502@s5r6.in-berlin.de> <1237402251.14147.5.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46492 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbZCRTqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2009 15:46:22 -0400
In-Reply-To: <1237402251.14147.5.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: Konrad Rzeszutek <konrad@virtualiron.com>, linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

Chandra Seetharaman wrote:
> yes (all others are off).
> 
>  that is the only storage I have in my system

My mistake.

>>> On Wed, 2009-03-18 at 16:43 +0100, Stefan Richter wrote:
>>>> AFAICS you could have kept the check for .vendor != NULL instead of
>>>> .vendor[0] != '\0'

Wrong.

>>>> and write the terminator thusly:
>>>>
>>>> 	{},

Right.

>>>> Saves the space for a one byte long string in the object files.  :-)

Wrong.
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
