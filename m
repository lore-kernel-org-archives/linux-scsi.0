From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command
 to the host
Date: Sun, 4 Mar 2012 14:23:28 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B74886F@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1330721347-26781-1-git-send-email-kys@microsoft.com>
 <20120304091225.GA27297@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120304091225.GA27297@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Sunday, March 04, 2012 4:12 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> Haiyang Zhang
> Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Don't pass ATA_16 command to
> the host
> 
> On Fri, Mar 02, 2012 at 12:49:07PM -0800, K. Y. Srinivasan wrote:
> > Windows hosts don't handle the ATA_16 command; don't pass it to the host.
> 
> Most devices don't handle it, and answer with and unsupported opcode
> sense reason.  If hyperv iis buggy enough to crap out on it please add
> a comment explaining that.

The host does not "crap out", it does return an error code but it is not "unsupported opcode".
The sense reason that comes back is a generic error SRB_STATUS code. It is easier for me to filter the
command on the outgoing side as opposed to dealing with a generic error code that is coming back from
the host.

Regards,

K. Y 
