From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [sg3_utils] report target group
Date: Wed, 29 Dec 2004 13:00:45 +1000
Message-ID: <41D21DDD.5010109@torque.net>
References: <1104233396.41d143b44e073@imp5-q.free.fr>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:19117 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261315AbUL2C7F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Dec 2004 21:59:05 -0500
In-Reply-To: <1104233396.41d143b44e073@imp5-q.free.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: linux-scsi@vger.kernel.org

christophe.varoqui@free.fr wrote:
> Hello,
> 
> can someone with the appropriate hardware (SCCS == 1 in sg_inq) can audit the
> following sg_rtg command.

Christophe,
I think the condition should be 'TPGS > 0' in a standard
INQUIRY response (not necessarily the SCCS bit set).

> This command is proposed for inclusion in sg3_utils.

Included in sg3_utils-1.12 beta which can be found at
http://www.torque.net/sg [in the news section]. I made
a few superficial changes. None of my hardware sets
'TPGS > 0' so I hope someone who has such hardware
can test it.

Doug Gilbert
