From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: sd driver
Date: Tue, 24 May 2005 14:02:44 +0200
Message-ID: <1116936165.6280.19.camel@laptopd505.fenrus.org>
References: <42919ABC.9030508@netstorage.it> <4292C7C4.2030204@torque.net>
	 <429316D5.6050000@netstorage.it>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:915 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261998AbVEXMCw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 08:02:52 -0400
In-Reply-To: <429316D5.6050000@netstorage.it>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aldo Gavioli <aldo.gavioli@netstorage.it>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org


> We cannot denied to load different drivers than sd for type MOD.

why not? 
> This behaviour will generate other troubles in developper community.

which community?

again I asked you a question which you didn't bother to answer yet:
Did you write your closed module with linux in mind or even specifically
for linux? Because if so it *really* is better for everyone if you could
show code on how to deal with your device instead, so that generic linux
will work with it. (and it also avoids a big mess wrt GPL issues)

