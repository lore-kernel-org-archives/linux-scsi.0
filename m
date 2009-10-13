From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 11/12] scsi: megaraid_sas - Add the 3 mins support
 during the FW boot-up and fixed the 64 bit sense buff error.
Date: Tue, 13 Oct 2009 12:41:25 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3B772447A@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C35C5119D7@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C512407@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C6861F3@cosmail02.lsi.com>
 <1255455442.2855.230.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934059AbZJMSmV@vger.kernel.org>
In-Reply-To: <1255455442.2855.230.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "Mukker, Atul" <Atul.Mukker@lsi.com>
List-Id: linux-scsi@vger.kernel.org

James,

Thanks for the review.  Agree with you. I saw you already split this patch in two.  Thanks so much for doing that. 

Bo Yang

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Tuesday, October 13, 2009 1:37 PM
To: Yang, Bo
Cc: linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org; Austria, Winston; Mukker, Atul
Subject: Re: [PATCH 11/12] scsi: megaraid_sas - Add the 3 mins support during the FW boot-up and fixed the 64 bit sense buff error.

On Tue, 2009-10-06 at 14:52 -0600, Yang, Bo wrote:
> RESUBMIT:
> 
> Add the 3 mins support during the FW boot-up to the driver.  Also add the fix for the 64 bit sense buff error.

OK, so this one has to be split ... that's a timing enhancement mixed
with a bug fix which seems to be very real and need backporting

James
