From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 6/7] scsi: megaraid_sas - Add three times Online
 controller reset - V2
Date: Tue, 25 May 2010 12:32:16 -0500
Message-ID: <1274808736.5300.133.camel@mulgrave.site>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C35C6861A5@cosmail02.lsi.com>
	 <3A916D859199814BBB666188F96EB165013979165E@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C3CDB80B82@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C3CDB80C32@cosmail02.lsi.com>
	 <4BFBF814.5040202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BFBF814.5040202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "Yang, Bo" <Bo.Yang@lsi.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-05-25 at 18:17 +0200, Tomas Henzl wrote:
> V2: I've cleaned up some coding style issues and removed a variable, the functionality shouldn't be changed
> 
> Tomas
> 
> If fw didn't raise the interrupt with the fw state change to driver and fw goes to failure state, driver
> Will check the FW state in driver's timeout routine and issue the reset if need.  Driver will do the OCR upto three
> Times until kill adapter.  Also driver will issue OCR before driver kill adapter even if fw in operational state.   

So there's supposed to be a replacement for 3/7 (megaraid_sas - Online
COntroller Reset (OCR) PART-III) as well, isn't there?

Also descriptive subjects would be nice (parts I-III may do well for
Lord of the Rings ... it's less useful for SCSI patches).

James
