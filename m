From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2.6.16-rc6] Promise SuperTrak driver
Date: Tue, 14 Mar 2006 04:27:34 -0500
Message-ID: <44168C86.8060107@garzik.org>
References: <NONAMEBgJJ72jYxDwLd000000d3@nonameb.ptu.promise.com> <1142327906.3027.24.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:27816 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751875AbWCNJ1l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 04:27:41 -0500
In-Reply-To: <1142327906.3027.24.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ed Lin <ed.lin@promise.com>, Andrew Morton <akpm@osdl.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "promise_linux@promise.com" <promise_linux@promise.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Arjan van de Ven wrote:
>>>>+struct st_sgitem {
>>>>+struct st_sgtable {
>>>>+struct handshake_frame {
>>>>+struct req_msg {
>>>>+struct status_msg {
>>>
>>>Has this all been tested on big-endian hardware?
>>>
>>
>>No. It was only tested on i386 and x86-64 machines.
> 
> 
> you'll want those to be __attribute__((packed)) as well btw

I thought that was unnecessary if the struct members are ordered such 
that compiler would not add padding?

	Jeff



