From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC pass thru - Rev IV
Date: Mon, 1 Dec 2008 17:09:48 -0500
Message-ID: <493460AC.9050007@emulex.com>
References: <1227043498.4949.21.camel@ogier> <C49C4ADF-8DA1-4D86-AEBB-AC46A04FCA62@qlogic.com> <492B1685.4020709@emulex.com> <F285E2FA-64A5-4BB6-ACC4-1B31EB19AFE6@qlogic.com> <BA2B0040-C95D-42CE-9D12-EF8E1A752328@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38949 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbYLAWI5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 17:08:57 -0500
In-Reply-To: <BA2B0040-C95D-42CE-9D12-EF8E1A752328@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>, "sven@linux.vnet.ibm.com" <sven@linux.vnet.ibm.com>


Seokmann Ju wrote:
> One minor questions/clarification.
> If I understood correctly, ELS only supports single sg. If this is
> true, shouldn't it checked somewhere before the transport layer calls
> LLD?

I didn't think we needed to mandate this. So, I've left it in the 
position where the transport allows it to be more than one, but the 
driver is free to reject it if it desires.  That said, I wouldn't expect 
an ELS to be more than 1 buffer.  If everyone feels strongly enough 
about it - we can make this restriction.

However, we can't do this on CT operations.

-- james
