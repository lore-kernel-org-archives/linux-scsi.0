From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [sg3_utils] report target group
Date: Sat, 01 Jan 2005 14:14:55 +1000
Message-ID: <41D623BF.8060304@torque.net>
References: <1104233396.41d143b44e073@imp5-q.free.fr> <41D21DDD.5010109@torque.net> <1104307397.41d264c5c5d3c@imp5-q.free.fr> <41D2AF42.5050007@torque.net> <1104327781.41d2b4654846d@imp5-q.free.fr> <41D38DBF.6010303@torque.net> <1104415233.41d40a018c287@imp5-q.free.fr> <1104415927.41d40cb782493@imp5-q.free.fr>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:50655 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S262186AbVAAENP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2004 23:13:15 -0500
In-Reply-To: <1104415927.41d40cb782493@imp5-q.free.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: linux-scsi@vger.kernel.org

christophe.varoqui@free.fr wrote:
>>All in all, I don't really see how one can use the result of RTPG.
>>
> 
> Ok, sorry to bug around.
> the response is at chapter 7.6.8 of SPC-3 :
> VPD page 88h contains the mapping between relative port ids and port ids

sg_inq -s /dev/sda

decodes the SCSI Ports VPD (0x88) page. Evidentally it will
be present in SAS dual ported disks.

So is sg_rtpg of any use?

Doug Gilbert

