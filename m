From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 4/5] Staging: hv: storvsc: Fix a bug in
 copy_from_bounce_buffer()
Date: Thu, 1 Dec 2011 21:13:34 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA7B529@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1322744315-13017-1-git-send-email-kys@microsoft.com>
 <1322744360-13067-1-git-send-email-kys@microsoft.com>
 <1322744360-13067-4-git-send-email-kys@microsoft.com>
 <20111201210304.GY3195@mwanda>
 <6E21E5352C11B742B20C142EB499E0481AA7B4EF@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20111201211147.GL20466@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111201211147.GL20466@mwanda>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Thursday, December 01, 2011 4:12 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> James.Bottomley@HansenPartnership.com; hch@infradead.org; linux-
> scsi@vger.kernel.org; Haiyang Zhang
> Subject: Re: [PATCH 4/5] Staging: hv: storvsc: Fix a bug in
> copy_from_bounce_buffer()
> 
> On Thu, Dec 01, 2011 at 09:07:46PM +0000, KY Srinivasan wrote:
> > Sorry Dan. I put in some comments in the code describing the bug. Perhaps I
> > should have copied that in the changelog as well.
> 
> Yes.  That's the entire point of the changelog, in fact.  Could you
> fix it and resend?

I could do that, but Greg has already checked in this patch. 

Regards,

K. Y
