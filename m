From: "Jan Beulich" <jbeulich@novell.com>
Subject: RE: MSI override changes in mptbase
Date: Tue, 10 Mar 2009 13:41:48 +0000
Message-ID: <49B67C2C.76E4.0078.0@novell.com>
References: <49B6559C.76E4.0078.0@novell.com>
 <0D1E8821739E724A86F4D16902CE275C140E25C9F9@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.id2.novell.com ([195.33.99.129]:15588 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbZCJN7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2009 09:59:34 -0400
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C140E25C9F9@inbmail01.lsi.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <Kashyap.Desai@lsi.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "yinghai@kernel.org" <yinghai@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>> "Desai, Kashyap" <Kashyap.Desai@lsi.com> 10.03.09 13:12 >>>
>Default behavior for all 3 buses (FC, SPI, and SAS) with respect to MSI is OFF. It is up to user, whether they want to enable/disable >MSI.

Why is that change in behavior for SAS needed then?

Thanks, Jan

