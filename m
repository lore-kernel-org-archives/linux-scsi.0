From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [sg3_utils] report target group
Date: Wed, 29 Dec 2004 23:21:06 +1000
Message-ID: <41D2AF42.5050007@torque.net>
References: <1104233396.41d143b44e073@imp5-q.free.fr> <41D21DDD.5010109@torque.net> <1104307397.41d264c5c5d3c@imp5-q.free.fr>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:61828 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261309AbUL2NT2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Dec 2004 08:19:28 -0500
In-Reply-To: <1104307397.41d264c5c5d3c@imp5-q.free.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: linux-scsi@vger.kernel.org

christophe.varoqui@free.fr wrote:
>>I think the condition should be 'TPGS > 0' in a standard
>>INQUIRY response (not necessarily the SCCS bit set).
>>
> 
> Right, I didn't noticed the ALUA field got renamed to TPGS.
> 
> 
>>Included in sg3_utils-1.12 beta which can be found at
>>http://www.torque.net/sg [in the news section]. I made
>>a few superficial changes. None of my hardware sets
>>'TPGS > 0' so I hope someone who has such hardware
>>can test it.
>>
> 
> I don't have the hardware either.
> 
> Line 206 & 214 in sg_rtg.c the payload offset might be 4 instead of 6, according
> to the spec (page 216).

Christophe,
I have uploaded a new beta of the sg3_utils v1.12
tarball. The response decoding in sg_rtg has been
reworked.

If the '#define TEST_CODE" line is uncommented in
sg_rtg.c then the utility will decode a dummy response
(constructed from the SPC-3 v21b response description).
I also took some liberties with the formatting.

Doug Gilbert

