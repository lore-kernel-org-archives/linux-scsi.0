From: Martin Peschke <mp3@de.ibm.com>
Subject: Re: [Patch] SCSI statistics
Date: Tue, 19 Sep 2006 18:33:14 +0200
Message-ID: <45101BCA.6090608@de.ibm.com>
References: <1158578439.3060.50.camel@dyn-9-152-230-71.boeblingen.de.ibm.com> <1158614913.3182.78.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:11808 "EHLO
	mtagate4.uk.ibm.com") by vger.kernel.org with ESMTP id S932314AbWISQd0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 12:33:26 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.8/8.13.8) with ESMTP id k8JGXPlg039564
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 16:33:25 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8JGZcBv1368112
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 17:35:38 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8JGXObT013604
	for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2006 17:33:24 +0100
In-Reply-To: <1158614913.3182.78.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 2006-09-18 at 13:20 +0200, Martin Peschke wrote:
>> This patch makes the SCSI mid layer report statistics data, i.e. request
>> sizes, request latencies, request results and queue utilisation.
>> For sample output please see below. This data is only gathered if these
>> statistics have been enabled by users at run time (default is off).
>>
>> It is crucial (for us) to be able to look at such kernel level data in
>> case of customer situations. It allows us to determine what kind of
>> requests might be involved in performance situations. This information
>> helps to understand whether one faces a device issue or a Linux issue.
>> Not being able to tap into performance data is regarded as a big minus
>> by some enterprise customers, who are reluctant to use Linux SCSI
>> support or Linux.
>>
>> Patch is against 2.6.18-rc6-mm2, as it requires the statistics
>> infrastructure patches.
> 
> 
> wouldn't this be nicer as a block level functionality?

I won't mind as long as the data closely resembles the actual
I/O traffic to and from devices.

