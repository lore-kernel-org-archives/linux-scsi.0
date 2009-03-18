From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/3] scsi_dh: Change scsi device handler modules to 	utilize
 modalias
Date: Wed, 18 Mar 2009 20:44:05 +0100
Message-ID: <49C14F05.7060309@s5r6.in-berlin.de>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>	 <20090318013627.26548.27704.sendpatchset@chandra-ubuntu>	 <20090318134629.GB19448@mars.virtualiron.com>	 <49C1168F.6060900@s5r6.in-berlin.de>	 <1237397158.14147.3.camel@chandra-ubuntu>	 <49C1344D.30502@s5r6.in-berlin.de> <ac3eb2510903181118h7a28e0a2m88aa62cbf68f0fe8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46475 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZCRToP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2009 15:44:15 -0400
In-Reply-To: <ac3eb2510903181118h7a28e0a2m88aa62cbf68f0fe8@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: sekharan@linux.vnet.ibm.com, Konrad Rzeszutek <konrad@virtualiron.com>, linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@hansenpartnership.com

Kay Sievers wrote:
> On Wed, Mar 18, 2009 at 18:50, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Chandra Seetharaman wrote:
>>> On Wed, 2009-03-18 at 16:43 +0100, Stefan Richter wrote:
>>>> AFAICS you could have kept the check for .vendor != NULL instead of
>>>> .vendor[0] != '\0' and write the terminator thusly:
>>>>
>>>>      {},
>>>>
>>>> Saves the space for a one byte long string in the object files.  :-)
>>> Tried it after your response. Got a panic :(.
> 
> It's a static char array not a pointer to a string.

Right, I missed that part of the switch from struct scsi_dh_devlist to
struct scsi_dh_device_id.  #-|
-- 
Stefan Richter
-=====-=-=== -=-= -==-=
http://arcgraph.de/sr/
