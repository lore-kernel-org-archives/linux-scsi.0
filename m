From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 11/12] scsi: megaraid_sas - Add the 3 mins support
 during the FW boot-up and fixed the 64 bit sense buff error.
Date: Tue, 13 Oct 2009 12:37:22 -0500
Message-ID: <1255455442.2855.230.camel@localhost.localdomain>
References: <4B6A08C587958942AA3002690DD4F8C35C5119D7@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C512407@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C6861F3@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44465 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885AbZJMRiA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 13:38:00 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C6861F3@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "Mukker, Atul" <Atul.Mukker@lsi.com>

On Tue, 2009-10-06 at 14:52 -0600, Yang, Bo wrote:
> RESUBMIT:
> 
> Add the 3 mins support during the FW boot-up to the driver.  Also add the fix for the 64 bit sense buff error.

OK, so this one has to be split ... that's a timing enhancement mixed
with a bug fix which seems to be very real and need backporting

James


