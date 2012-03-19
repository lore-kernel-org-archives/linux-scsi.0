From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH RESEND  0000/0002] drivers: scsi: storvsc
Date: Mon, 19 Mar 2012 00:01:17 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B767CB5@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1332100789-25594-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1332100789-25594-1-git-send-email-kys@microsoft.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: devel-bounces@linuxdriverproject.org
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Please drop these two patches. It looks like I sent out the wrong set of patches.
I will send the ones I wanted to send shortly.

Regards,

K. Y

> -----Original Message-----
> From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> Sent: Sunday, March 18, 2012 4:00 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Cc: KY Srinivasan
> Subject: [PATCH RESEND 0000/0002] drivers: scsi: storvsc
> 
> 
> The current Windows hosts only handle a subset of scsi commands
> sent from the guest and for commands that are not supported, they are
> filtered on the host side a generic failure is returned to the guest
> as SRB status. The returned error code does not permit the guest to
> figure out if there was an error or if the command was not supported.
> 
> Based on the input I got from the community, I have convinced the windows
> developers to return an error code that allows the guest to distinguish between
> unsupported command and true failures. However, it is not clear when this fix
> will
> be shipped.
> 
> This patch set addresses this issue by filtering the ATA_16 command on the guest
> (note that currently the host is filtering this command as it is not supported).
> I also have a patch here the correctly handles SRB_STATUS_INVALID_REQUEST
> error returns - note that the current windows hosts don't return this today.
> 
> This is a resend of the patches sent earlier based on suggestions from
> Jeff Garzik <jgpobox@gmail.com> and Douglas Gilbert <dgilbert@interlog.com>.
> 
> 
> Regards,
> 
> K. Y
